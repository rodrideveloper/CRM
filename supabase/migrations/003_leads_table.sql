-- ============================================================
-- Migration 003: Leads table for landing page capture
-- ============================================================

CREATE TABLE public.leads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT,
  phone TEXT NOT NULL,
  source TEXT NOT NULL DEFAULT 'landing',  -- landing, tiktok, instagram, ad, referral
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  contacted_at TIMESTAMPTZ
);

-- Allow anonymous inserts (landing page visitors)
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can insert a lead"
  ON public.leads
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Only authenticated users (admin) can read leads
CREATE POLICY "Authenticated users can read leads"
  ON public.leads
  FOR SELECT
  TO authenticated
  USING (true);

-- Only authenticated users can update leads
CREATE POLICY "Authenticated users can update leads"
  ON public.leads
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);
