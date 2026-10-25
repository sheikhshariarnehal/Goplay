-- Migration: Unified stream_servers, Health Monitoring, Performance Indexes, and Strict RLS Lockdown

-- ============================================================================
-- 1. EXTEND stream_servers WITH HEALTH MONITORING COLUMNS
-- ============================================================================
ALTER TABLE public.stream_servers
  ADD COLUMN IF NOT EXISTS health_status TEXT DEFAULT 'unknown' CHECK (health_status IN ('working', 'slow', 'offline', 'unknown')),
  ADD COLUMN IF NOT EXISTS latency_ms INTEGER,
  ADD COLUMN IF NOT EXISTS consecutive_failures INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS last_checked_at TIMESTAMPTZ;

-- ============================================================================
-- 2. MIGRATE EXISTING channels.stream_url INTO stream_servers
-- ============================================================================
-- Insert a 'Server 1 (Primary)' row for any channel that has a stream_url
-- but does not yet have any entries in stream_servers.
INSERT INTO public.stream_servers (
  channel_id,
  name,
  stream_url,
  scheme,
  drm,
  headers,
  has_header,
  has_vpn_detection,
  sort_order,
  active,
  health_status,
  created_at,
  updated_at
)
SELECT
  c.id AS channel_id,
  'Server 1 (Primary)' AS name,
  c.stream_url,
  CASE WHEN c.stream_url ILIKE '%.mpd%' THEN 1 ELSE 0 END AS scheme,
  c.drm,
  COALESCE(c.headers, '{}'::jsonb) AS headers,
  CASE WHEN c.headers IS NOT NULL AND c.headers <> '{}'::jsonb THEN true ELSE false END AS has_header,
  COALESCE(c.has_vpn_detection, false) AS has_vpn_detection,
  0 AS sort_order,
  true AS active,
  'unknown' AS health_status,
  now() AS created_at,
  now() AS updated_at
FROM public.channels c
WHERE c.stream_url IS NOT NULL 
  AND c.stream_url <> ''
  AND NOT EXISTS (
    SELECT 1 FROM public.stream_servers ss WHERE ss.channel_id = c.id
  );

-- ============================================================================
-- 3. BIDIRECTIONAL SYNC TRIGGER: stream_servers -> channels.stream_url
-- ============================================================================
-- Keeps channels.stream_url mirrored with the primary active server (sort_order = 0)
-- so older APK releases and legacy endpoints continue functioning without breakage.

CREATE OR REPLACE FUNCTION public.sync_channel_primary_stream()
RETURNS TRIGGER AS $$
DECLARE
  primary_server RECORD;
BEGIN
  -- Determine the channel_id affected
  IF TG_OP = 'DELETE' THEN
    SELECT stream_url INTO primary_server
    FROM public.stream_servers
    WHERE channel_id = OLD.channel_id AND active = true
    ORDER BY sort_order ASC, created_at ASC
    LIMIT 1;

    UPDATE public.channels
    SET stream_url = COALESCE(primary_server.stream_url, '')
    WHERE id = OLD.channel_id;

    RETURN OLD;
  ELSE
    SELECT stream_url INTO primary_server
    FROM public.stream_servers
    WHERE channel_id = NEW.channel_id AND active = true
    ORDER BY sort_order ASC, created_at ASC
    LIMIT 1;

    IF primary_server.stream_url IS NOT NULL THEN
      UPDATE public.channels
      SET stream_url = primary_server.stream_url
      WHERE id = NEW.channel_id;
    END IF;

    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_sync_channel_primary_stream ON public.stream_servers;

CREATE TRIGGER trg_sync_channel_primary_stream
  AFTER INSERT OR UPDATE OR DELETE ON public.stream_servers
  FOR EACH ROW
  EXECUTE FUNCTION public.sync_channel_primary_stream();

-- ============================================================================
-- 4. HIGH-PERFORMANCE COMPOSITE INDEXES
-- ============================================================================
-- Fast lookup for channel playback streams ordered by priority
CREATE INDEX IF NOT EXISTS idx_stream_servers_channel_sort
  ON public.stream_servers (channel_id, sort_order ASC, active);

-- Fast lookup for the health scanner to query active servers
CREATE INDEX IF NOT EXISTS idx_stream_servers_health_active
  ON public.stream_servers (active, health_status, last_checked_at);

-- Fast category filtering on channels
CREATE INDEX IF NOT EXISTS idx_channels_category_sort
  ON public.channels (category, sort_order ASC);

-- Fast trending channels lookup
CREATE INDEX IF NOT EXISTS idx_channels_trending_sort
  ON public.channels (is_trending, sort_order ASC)
  WHERE is_trending = true;

-- ============================================================================
-- 5. ROW LEVEL SECURITY (RLS) LOCKDOWN
-- ============================================================================
-- Enable RLS across core tables
ALTER TABLE public.stream_servers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.channels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

-- Drop obsolete or overly permissive policies on stream_servers
DROP POLICY IF EXISTS "Admin all access stream servers" ON public.stream_servers;
DROP POLICY IF EXISTS "Public read stream servers" ON public.stream_servers;
DROP POLICY IF EXISTS "Public read active stream servers" ON public.stream_servers;
DROP POLICY IF EXISTS "Service role full access stream servers" ON public.stream_servers;

-- Read-only policy for anon/authenticated clients: only active stream servers
CREATE POLICY "Public read active stream servers"
  ON public.stream_servers FOR SELECT
  TO anon, authenticated
  USING (active = true);

-- Admin & Service Role write access policy
CREATE POLICY "Service role full access stream servers"
  ON public.stream_servers FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Ensure public read for channels & categories
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'channels' AND policyname = 'Public read channels'
  ) THEN
    CREATE POLICY "Public read channels"
      ON public.channels FOR SELECT
      TO anon, authenticated
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'channels' AND policyname = 'Service role full access channels'
  ) THEN
    CREATE POLICY "Service role full access channels"
      ON public.channels FOR ALL
      TO service_role
      USING (true)
      WITH CHECK (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'categories' AND policyname = 'Public read categories'
  ) THEN
    CREATE POLICY "Public read categories"
      ON public.categories FOR SELECT
      TO anon, authenticated
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'categories' AND policyname = 'Service role full access categories'
  ) THEN
    CREATE POLICY "Service role full access categories"
      ON public.categories FOR ALL
      TO service_role
      USING (true)
      WITH CHECK (true);
  END IF;
END $$;
