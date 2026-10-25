-- ==============================================================================
-- DYNAMIC TRENDING CHANNELS MIGRATION
-- ==============================================================================
-- 1. Create table for tracking unique device playback sessions per hour
CREATE TABLE IF NOT EXISTS public.channel_playback_events (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  channel_id TEXT NOT NULL REFERENCES public.channels(id) ON DELETE CASCADE,
  device_id TEXT NOT NULL,
  hour_bucket TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT unique_channel_device_hour UNIQUE (channel_id, device_id, hour_bucket)
);

-- Index for rolling window queries
CREATE INDEX IF NOT EXISTS idx_playback_events_lookup 
  ON public.channel_playback_events (hour_bucket DESC, channel_id);

-- Enable RLS
ALTER TABLE public.channel_playback_events ENABLE ROW LEVEL SECURITY;

-- Allow anon select and insert if needed, but primary interaction will be via SECURITY DEFINER functions
CREATE POLICY "Allow public read access on channel_playback_events"
  ON public.channel_playback_events FOR SELECT
  TO anon, authenticated
  USING (true);

-- 2. Stored procedure to record a verified channel play from devices
CREATE OR REPLACE FUNCTION public.record_channel_playback(
  p_channel_id TEXT,
  p_device_id TEXT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF p_channel_id IS NULL OR p_device_id IS NULL OR p_channel_id = '' OR p_device_id = '' THEN
    RETURN;
  END IF;

  INSERT INTO public.channel_playback_events (channel_id, device_id, hour_bucket)
  VALUES (
    p_channel_id,
    p_device_id,
    date_trunc('hour', NOW() AT TIME ZONE 'UTC')
  )
  ON CONFLICT (channel_id, device_id, hour_bucket) DO NOTHING;
END;
$$;

-- Grant execution to anon and authenticated
GRANT EXECUTE ON FUNCTION public.record_channel_playback(TEXT, TEXT) TO anon, authenticated, service_role;

-- 3. Stored procedure to get top trending channels (Admin Pinned first + Dynamic fill up to p_limit)
CREATE OR REPLACE FUNCTION public.get_trending_channels(
  p_limit INT DEFAULT 20
)
RETURNS TABLE (
  id TEXT,
  name TEXT,
  logo TEXT,
  category TEXT,
  country TEXT,
  language TEXT,
  is_live BOOLEAN,
  is_trending BOOLEAN,
  quality TEXT,
  stream_url TEXT,
  headers JSONB,
  sort_order INT,
  proxy BOOLEAN,
  drm JSONB,
  playz_links TEXT,
  is_playlist BOOLEAN,
  link_names TEXT[],
  has_vpn_detection BOOLEAN,
  is_pinned BOOLEAN,
  play_count BIGINT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  WITH dynamic_stats AS (
    SELECT 
      cpe.channel_id,
      COUNT(DISTINCT cpe.device_id) AS session_count
    FROM public.channel_playback_events cpe
    WHERE cpe.hour_bucket >= NOW() - INTERVAL '48 hours'
    GROUP BY cpe.channel_id
  ),
  pinned_channels AS (
    SELECT 
      c.id,
      c.name,
      c.logo,
      c.category,
      c.country,
      c.language,
      c.is_live,
      c.is_trending,
      c.quality,
      c.stream_url,
      c.headers,
      c.sort_order,
      c.proxy,
      c.drm,
      c.playz_links,
      c.is_playlist,
      c.link_names,
      c.has_vpn_detection,
      TRUE AS is_pinned,
      COALESCE(ds.session_count, 0::BIGINT) AS play_count,
      c.sort_order AS display_priority
    FROM public.channels c
    LEFT JOIN dynamic_stats ds ON ds.channel_id = c.id
    WHERE c.is_trending = TRUE
    ORDER BY c.sort_order ASC
    LIMIT p_limit
  ),
  dynamic_channels AS (
    SELECT 
      c.id,
      c.name,
      c.logo,
      c.category,
      c.country,
      c.language,
      c.is_live,
      c.is_trending,
      c.quality,
      c.stream_url,
      c.headers,
      c.sort_order,
      c.proxy,
      c.drm,
      c.playz_links,
      c.is_playlist,
      c.link_names,
      c.has_vpn_detection,
      FALSE AS is_pinned,
      COALESCE(ds.session_count, 0::BIGINT) AS play_count,
      (1000000 - COALESCE(ds.session_count, 0))::INT AS display_priority
    FROM public.channels c
    LEFT JOIN dynamic_stats ds ON ds.channel_id = c.id
    WHERE c.is_trending = FALSE
      AND (c.is_live IS NULL OR c.is_live = TRUE)
      AND c.id NOT IN (SELECT pc.id FROM pinned_channels pc)
    ORDER BY COALESCE(ds.session_count, 0) DESC, c.sort_order ASC
    LIMIT GREATEST(0, p_limit - (SELECT COUNT(*)::INT FROM pinned_channels))
  ),
  combined AS (
    SELECT * FROM pinned_channels
    UNION ALL
    SELECT * FROM dynamic_channels
  )
  SELECT 
    cb.id,
    cb.name,
    cb.logo,
    cb.category,
    cb.country,
    cb.language,
    cb.is_live,
    cb.is_trending,
    cb.quality,
    cb.stream_url,
    cb.headers,
    cb.sort_order,
    cb.proxy,
    cb.drm,
    cb.playz_links,
    cb.is_playlist,
    cb.link_names,
    cb.has_vpn_detection,
    cb.is_pinned,
    cb.play_count
  FROM combined cb
  ORDER BY cb.is_pinned DESC, cb.display_priority ASC
  LIMIT p_limit;
END;
$$;

-- Grant execution to anon and authenticated
GRANT EXECUTE ON FUNCTION public.get_trending_channels(INT) TO anon, authenticated, service_role;

-- 4. Routine cleanup helper (optional cron or maintenance)
CREATE OR REPLACE FUNCTION public.cleanup_old_playback_events()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  DELETE FROM public.channel_playback_events
  WHERE hour_bucket < NOW() - INTERVAL '7 days';
END;
$$;
