-- Create hero_banners table
CREATE TABLE IF NOT EXISTS public.hero_banners (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT,
  image_url TEXT NOT NULL,
  badge_text TEXT,
  show_title BOOLEAN NOT NULL DEFAULT true,
  show_badge BOOLEAN NOT NULL DEFAULT true,
  action_type TEXT NOT NULL DEFAULT 'none', -- 'none' | 'url' | 'channel'
  action_value TEXT,                        -- Target URL or Channel ID
  active BOOLEAN NOT NULL DEFAULT true,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.hero_banners ENABLE ROW LEVEL SECURITY;

-- Policies for public reading and admin writes
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'hero_banners' AND policyname = 'Public read hero banners'
  ) THEN
    CREATE POLICY "Public read hero banners"
      ON public.hero_banners FOR SELECT
      USING (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'hero_banners' AND policyname = 'Admin all access hero banners'
  ) THEN
    CREATE POLICY "Admin all access hero banners"
      ON public.hero_banners FOR ALL
      TO authenticated, anon
      USING (true)
      WITH CHECK (true);
  END IF;
END $$;

-- Storage Bucket for hero-banners
INSERT INTO storage.buckets (id, name, public)
VALUES ('hero-banners', 'hero-banners', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Storage policies
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'objects' AND policyname = 'Public read hero-banners storage'
  ) THEN
    CREATE POLICY "Public read hero-banners storage"
      ON storage.objects FOR SELECT
      USING (bucket_id = 'hero-banners');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'objects' AND policyname = 'Public insert hero-banners storage'
  ) THEN
    CREATE POLICY "Public insert hero-banners storage"
      ON storage.objects FOR INSERT
      WITH CHECK (bucket_id = 'hero-banners');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'objects' AND policyname = 'Public update hero-banners storage'
  ) THEN
    CREATE POLICY "Public update hero-banners storage"
      ON storage.objects FOR UPDATE
      USING (bucket_id = 'hero-banners');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'objects' AND policyname = 'Public delete hero-banners storage'
  ) THEN
    CREATE POLICY "Public delete hero-banners storage"
      ON storage.objects FOR DELETE
      USING (bucket_id = 'hero-banners');
  END IF;
END $$;
