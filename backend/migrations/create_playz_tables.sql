-- Migration: Create PlayZ Architecture Tables (playz_categories, playz_channels, playz_stream_servers)
-- Non-breaking addition alongside existing categories and channels tables.

-- 1. playz_categories
CREATE TABLE IF NOT EXISTS public.playz_categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  logo_url TEXT,
  type TEXT NOT NULL DEFAULT 'custom' CHECK (type IN ('custom', 'm3u')),
  playz_endpoint TEXT,
  m3u_url TEXT,
  xor_key TEXT DEFAULT '',
  has_header BOOLEAN DEFAULT false,
  has_vpn_detection BOOLEAN DEFAULT false,
  sort_order INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. playz_channels
CREATE TABLE IF NOT EXISTS public.playz_channels (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  logo TEXT,
  category_id TEXT REFERENCES public.playz_categories(id) ON DELETE CASCADE,
  playz_links TEXT,
  is_playlist BOOLEAN DEFAULT false,
  link_names TEXT[] DEFAULT '{}',
  visible BOOLEAN DEFAULT true,
  has_vpn_detection BOOLEAN DEFAULT false,
  sort_order INTEGER DEFAULT 0,
  drm JSONB,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 3. playz_stream_servers
CREATE TABLE IF NOT EXISTS public.playz_stream_servers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  channel_id TEXT NOT NULL REFERENCES public.playz_channels(id) ON DELETE CASCADE,
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

-- Indexes for optimal lookup performance
CREATE INDEX IF NOT EXISTS idx_playz_categories_sort ON public.playz_categories(sort_order ASC, active);
CREATE INDEX IF NOT EXISTS idx_playz_channels_category ON public.playz_channels(category_id, sort_order ASC, visible);
CREATE INDEX IF NOT EXISTS idx_playz_stream_servers_channel ON public.playz_stream_servers(channel_id, sort_order ASC, active);

-- Enable Row Level Security (RLS)
ALTER TABLE public.playz_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.playz_channels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.playz_stream_servers ENABLE ROW LEVEL SECURITY;

-- Setup RLS Policies for Anon (read) & Admin (all)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'playz_categories' AND policyname = 'Public read playz categories'
  ) THEN
    CREATE POLICY "Public read playz categories"
      ON public.playz_categories FOR SELECT
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'playz_categories' AND policyname = 'Admin all access playz categories'
  ) THEN
    CREATE POLICY "Admin all access playz categories"
      ON public.playz_categories FOR ALL
      TO authenticated, anon
      USING (true)
      WITH CHECK (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'playz_channels' AND policyname = 'Public read playz channels'
  ) THEN
    CREATE POLICY "Public read playz channels"
      ON public.playz_channels FOR SELECT
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'playz_channels' AND policyname = 'Admin all access playz channels'
  ) THEN
    CREATE POLICY "Admin all access playz channels"
      ON public.playz_channels FOR ALL
      TO authenticated, anon
      USING (true)
      WITH CHECK (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'playz_stream_servers' AND policyname = 'Public read playz stream servers'
  ) THEN
    CREATE POLICY "Public read playz stream servers"
      ON public.playz_stream_servers FOR SELECT
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'playz_stream_servers' AND policyname = 'Admin all access playz stream servers'
  ) THEN
    CREATE POLICY "Admin all access playz stream servers"
      ON public.playz_stream_servers FOR ALL
      TO authenticated, anon
      USING (true)
      WITH CHECK (true);
  END IF;
END $$;

-- Seed initial master categories
INSERT INTO public.playz_categories (id, name, logo_url, type, playz_endpoint, m3u_url, sort_order, active)
VALUES
  ('bangla', 'Bangla', 'https://assets-playztv.pages.dev/category/bn.png', 'custom', 'channels/Qk4xNzY3MDIzMTU1NzMy.txt', NULL, 1, true),
  ('kolkata', 'Kolkata', 'https://assets-playztv.pages.dev/category/kolkata.jpg', 'custom', 'channels/S29sa2F0YTE3NjcwMDgwNjY5MDg.txt', NULL, 2, true),
  ('kids', 'Kids', 'https://assets-playztv.pages.dev/category/kids.jpg', 'custom', 'channels/S2lkczE3NjcwMDgyMjAzNzM.txt', NULL, 3, true),
  ('sports', 'Sports', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhyx-rZq_n38i8qJ85w-1E/s1600/1000407701.jpg', 'custom', 'channels/U3BvcnRzIDE3NjcwMDcwMjc1Njc.txt', NULL, 4, true),
  ('news', 'News', 'https://assets-playztv.pages.dev/category/news.jpg', 'custom', 'channels/TmV3czE3NjcwMDgxODM1MjQ.txt', NULL, 5, true),
  ('entertainment', 'Entertainment', 'https://assets-playztv.pages.dev/category/ent.jpg', 'custom', 'channels/RW50ZXJ0YWlubWVudDE3NjcwMDg0NDY4OTE.txt', NULL, 6, true),
  ('movie', 'Movie', 'https://assets-playztv.pages.dev/category/mov.jpg', 'custom', 'channels/TW92aWUxNzY3MDA4NDgxMzM3.txt', NULL, 7, true),
  ('music', 'Music', 'https://assets-playztv.pages.dev/category/music.jpg', 'custom', 'channels/TXVzaWMxNzY3MDA4NTMyNjM3.txt', NULL, 8, true),
  ('infotainment', 'Infotainment', 'https://assets-playztv.pages.dev/category/info.jpg', 'custom', 'channels/SW5mb3RhaW5tZW50MTc2NzAwODU2NjcwNg.txt', NULL, 9, true),
  ('islamic', 'Islamic', 'https://assets-playztv.pages.dev/category/isl.jpg', 'custom', 'channels/SXNsYW1pYzE3NjcwMDgyNTA2NzI.txt', NULL, 10, true),
  ('radio', 'Radio', 'https://assets-playztv.pages.dev/category/rad.jpg', 'custom', 'channels/UmFkaW8xNzY3MDA4Mjg0MjM5.txt', NULL, 11, true),
  ('nepal', 'Nepal', 'https://assets-playztv.pages.dev/category/np.jpg', 'custom', 'channels/TmVwYWwxNzY3MDI1MjMxODU0.txt', NULL, 12, true),
  ('pakistan', 'Pakistan', 'https://assets-playztv.pages.dev/category/pkk2.jpg', 'm3u', NULL, 'https://m3u-tvb.pages.dev/pk.m3ux', 13, true)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo_url = EXCLUDED.logo_url,
  type = EXCLUDED.type,
  playz_endpoint = EXCLUDED.playz_endpoint,
  m3u_url = EXCLUDED.m3u_url,
  sort_order = EXCLUDED.sort_order,
  active = EXCLUDED.active;
