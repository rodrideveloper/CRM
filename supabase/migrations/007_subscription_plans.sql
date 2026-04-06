-- ============================================================
-- Migration 007: Subscription plans (freemium model)
-- Free plan: 15 active clients limit
-- Pro plan: unlimited
-- ============================================================

-- 1. Add plan columns to user_profiles
ALTER TABLE user_profiles
  ADD COLUMN plan TEXT NOT NULL DEFAULT 'free',
  ADD COLUMN plan_expires_at TIMESTAMPTZ;

-- 2. Trigger: enforce client limit for free plan
CREATE OR REPLACE FUNCTION check_client_limit()
RETURNS TRIGGER AS $$
DECLARE
  v_plan TEXT;
  v_count INT;
BEGIN
  -- Get user plan
  SELECT plan INTO v_plan
  FROM public.user_profiles
  WHERE id = NEW.user_id;

  -- Pro users have no limit
  IF v_plan = 'pro' THEN
    RETURN NEW;
  END IF;

  -- Count active clients for this user
  SELECT COUNT(*) INTO v_count
  FROM public.clients
  WHERE user_id = NEW.user_id
    AND deleted_at IS NULL;

  -- Free plan limit: 15 active clients
  IF v_count >= 15 THEN
    RAISE EXCEPTION 'LIMIT_REACHED: Alcanzaste el límite de 15 clientes del plan gratuito. Actualizá a Pro para clientes ilimitados.';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_client_limit
  BEFORE INSERT ON clients
  FOR EACH ROW EXECUTE FUNCTION check_client_limit();

-- 3. RPC: get_user_limits (returns plan info + current usage)
CREATE OR REPLACE FUNCTION get_user_limits()
RETURNS JSON AS $$
DECLARE
  v_plan TEXT;
  v_expires TIMESTAMPTZ;
  v_count INT;
  v_limit INT;
BEGIN
  SELECT plan, plan_expires_at INTO v_plan, v_expires
  FROM public.user_profiles
  WHERE id = auth.uid();

  IF NOT FOUND THEN
    RAISE EXCEPTION 'User profile not found';
  END IF;

  SELECT COUNT(*) INTO v_count
  FROM public.clients
  WHERE user_id = auth.uid()
    AND deleted_at IS NULL;

  v_limit := CASE WHEN v_plan = 'pro' THEN -1 ELSE 15 END;

  RETURN json_build_object(
    'plan', v_plan,
    'plan_expires_at', v_expires,
    'client_count', v_count,
    'client_limit', v_limit
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_user_limits() TO authenticated;
