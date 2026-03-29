-- ============================================================
-- Migration 004: user_profiles table + submit_lead RPC
-- Enables public lead capture forms that create clients directly
-- ============================================================

-- 1. TABLE: user_profiles (stores form_token for public forms)
CREATE TABLE user_profiles (
  id           UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  form_token   UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
  form_enabled BOOLEAN NOT NULL DEFAULT true,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- User can read/update only their own profile
CREATE POLICY "user_profiles_select" ON user_profiles
  FOR SELECT TO authenticated
  USING ((SELECT auth.uid()) = id);

CREATE POLICY "user_profiles_update" ON user_profiles
  FOR UPDATE TO authenticated
  USING ((SELECT auth.uid()) = id)
  WITH CHECK ((SELECT auth.uid()) = id);

-- Trigger: auto-update updated_at
CREATE TRIGGER trg_user_profiles_updated_at
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- 2. TRIGGER: auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id)
  VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- 3. Backfill: create profiles for existing users
INSERT INTO user_profiles (id)
SELECT id FROM auth.users
ON CONFLICT (id) DO NOTHING;

-- 4. RPC: submit_lead (public, creates client via form_token)
CREATE OR REPLACE FUNCTION submit_lead(
  p_form_token UUID,
  p_name TEXT DEFAULT NULL,
  p_phone TEXT DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
  v_user_id UUID;
BEGIN
  -- Resolve form_token → user_id
  SELECT id INTO v_user_id
  FROM public.user_profiles
  WHERE form_token = p_form_token
    AND form_enabled = true;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Formulario no válido o deshabilitado';
  END IF;

  -- Validate at least phone is provided
  IF p_phone IS NULL OR trim(p_phone) = '' THEN
    RAISE EXCEPTION 'El teléfono es requerido';
  END IF;

  -- Insert client with status 'new' and source 'formulario'
  INSERT INTO public.clients (user_id, name, phone, source, status)
  VALUES (
    v_user_id,
    COALESCE(NULLIF(trim(p_name), ''), 'Sin nombre'),
    trim(p_phone),
    'formulario',
    'new'
  );

  RETURN json_build_object('success', true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute to anon (public forms) and authenticated
GRANT EXECUTE ON FUNCTION submit_lead(UUID, TEXT, TEXT) TO anon, authenticated;
