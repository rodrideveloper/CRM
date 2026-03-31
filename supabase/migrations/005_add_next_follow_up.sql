-- ============================================================
-- CRM MVP - Migration 005: Add next_follow_up to clients
-- Sprint: 5 | Fecha: 2026-03-31
-- ============================================================

BEGIN;

ALTER TABLE clients ADD COLUMN next_follow_up TIMESTAMPTZ;

CREATE INDEX idx_clients_follow_up ON clients(next_follow_up)
  WHERE next_follow_up IS NOT NULL AND deleted_at IS NULL;

COMMIT;
