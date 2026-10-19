-- Migration: Merge PlayZ Architecture into Core 'categories', 'channels', and 'stream_servers' tables
-- Clean up temporary playz_* tables.

-- 1. Extend public.categories with PlayZ columns
ALTER TABLE public.categories
  ADD COLUMN IF NOT EXISTS type TEXT NOT NULL DEFAULT 'custom' CHECK (type IN ('custom', 'm3u')),
  ADD COLUMN IF NOT EXISTS playz_endpoint TEXT,
  ADD COLUMN IF NOT EXISTS m3u_url TEXT,
  ADD COLUMN IF NOT EXISTS xor_key TEXT DEFAULT '',
  ADD COLUMN IF NOT EXISTS has_header BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS has_vpn_detection BOOLEAN DEFAULT false;

-- 2. Extend public.channels with PlayZ columns
ALTER TABLE public.channels
  ADD COLUMN IF NOT EXISTS playz_links TEXT,
  ADD COLUMN IF NOT EXISTS is_playlist BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS link_names TEXT[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS has_vpn_detection BOOLEAN DEFAULT false;

-- 3. Create unified public.stream_servers table
CREATE TABLE IF NOT EXISTS public.stream_servers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  channel_id TEXT NOT NULL REFERENCES public.channels(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  stream_url TEXT NOT NULL,
  scheme INTEGER DEFAULT 0,
  drm JSONB,
  headers JSONB,
  has_header BOOLEAN DEFAULT false,
  has_vpn_detection BOOLEAN DEFAULT false,
  sort_order INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Index for fast channel lookup
CREATE INDEX IF NOT EXISTS idx_stream_servers_channel
  ON public.stream_servers(channel_id, sort_order ASC, active);

-- Enable RLS on stream_servers
ALTER TABLE public.stream_servers ENABLE ROW LEVEL SECURITY;

-- Setup RLS Policies for stream_servers
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'stream_servers' AND policyname = 'Public read stream servers'
  ) THEN
    CREATE POLICY "Public read stream servers"
      ON public.stream_servers FOR SELECT
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'stream_servers' AND policyname = 'Admin all access stream servers'
  ) THEN
    CREATE POLICY "Admin all access stream servers"
      ON public.stream_servers FOR ALL
      TO authenticated, anon
      USING (true)
      WITH CHECK (true);
  END IF;
END $$;

-- 4. Upsert PlayZ categories directly into public.categories
INSERT INTO public.categories (id, name, icon_url, type, playz_endpoint, m3u_url, sort_order, active)
VALUES
  ('bangla', 'Bangla', 'https://assets-playztv.pages.dev/category/bn.png', 'custom', 'channels/Qk4xNzY3MDIzMTU1NzMy.txt', NULL, -3, true),
  ('kolkata', 'Kolkata', 'https://assets-playztv.pages.dev/category/kolkata.jpg', 'custom', 'channels/S29sa2F0YTE3NjcwMDgwNjY5MDg.txt', NULL, -2, true),
  ('kids', 'Kids', 'https://assets-playztv.pages.dev/category/kids.jpg', 'custom', 'channels/S2lkczE3NjcwMDgyMjAzNzM.txt', NULL, -1, true),
  ('sports', 'Sports', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhyx-rZq_n38i8qJ85w-1E/s1600/1000407701.jpg', 'custom', 'channels/U3BvcnRzIDE3NjcwMDcwMjc1Njc.txt', NULL, 1, true),
  ('news', 'News', 'https://assets-playztv.pages.dev/category/news.jpg', 'custom', 'channels/TmV3czE3NjcwMDgxODM1MjQ.txt', NULL, 2, true),
  ('entertainment', 'Entertainment', 'https://assets-playztv.pages.dev/category/ent.jpg', 'custom', 'channels/RW50ZXJ0YWlubWVudDE3NjcwMDg0NDY4OTE.txt', NULL, 3, true),
  ('movie', 'Movie', 'https://assets-playztv.pages.dev/category/mov.jpg', 'custom', 'channels/TW92aWUxNzY3MDA4NDgxMzM3.txt', NULL, 4, true),
  ('music', 'Music', 'https://assets-playztv.pages.dev/category/music.jpg', 'custom', 'channels/TXVzaWMxNzY3MDA4NTMyNjM3.txt', NULL, 5, true),
  ('infotainment', 'Infotainment', 'https://assets-playztv.pages.dev/category/info.jpg', 'custom', 'channels/SW5mb3RhaW5tZW50MTc2NzAwODU2NjcwNg.txt', NULL, 6, true),
  ('islamic', 'Islamic', 'https://assets-playztv.pages.dev/category/isl.jpg', 'custom', 'channels/SXNsYW1pYzE3NjcwMDgyNTA2NzI.txt', NULL, 7, true),
  ('radio', 'Radio', 'https://assets-playztv.pages.dev/category/rad.jpg', 'custom', 'channels/UmFkaW8xNzY3MDA4Mjg0MjM5.txt', NULL, 8, true),
  ('nepal', 'Nepal', 'https://assets-playztv.pages.dev/category/np.jpg', 'custom', 'channels/TmVwYWwxNzY3MDI1MjMxODU0.txt', NULL, 9, true),
  ('pakistan', 'Pakistan', 'https://assets-playztv.pages.dev/category/pkk2.jpg', 'm3u', NULL, 'https://m3u-tvb.pages.dev/pk.m3ux', 10, true)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  icon_url = COALESCE(EXCLUDED.icon_url, public.categories.icon_url),
  type = EXCLUDED.type,
  playz_endpoint = EXCLUDED.playz_endpoint,
  m3u_url = EXCLUDED.m3u_url,
  sort_order = EXCLUDED.sort_order,
  active = EXCLUDED.active;

-- 5. Drop temporary playz_* tables to keep database completely clean
DROP TABLE IF EXISTS public.playz_stream_servers CASCADE;
DROP TABLE IF EXISTS public.playz_channels CASCADE;
DROP TABLE IF EXISTS public.playz_categories CASCADE;
