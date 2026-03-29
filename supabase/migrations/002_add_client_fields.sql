-- ============================================================
-- CRM MVP - Migration 002: Add client fields + restore RPCs
-- Sprint: 2 | Fecha: 2026-03-29
-- ============================================================

-- Ejecutar en Supabase SQL Editor
-- https://supabase.com/dashboard/project/xxssynpydlfhjwkcipca/sql

BEGIN;

-- 1. New client fields
ALTER TABLE clients ADD COLUMN email   TEXT;
ALTER TABLE clients ADD COLUMN company TEXT;
ALTER TABLE clients ADD COLUMN source  TEXT;  -- 'whatsapp', 'referido', 'web', 'otro'

-- 2. Index for company search
CREATE INDEX idx_clients_company ON clients(company text_pattern_ops) WHERE deleted_at IS NULL;

-- 3. RPC functions for restoring soft-deleted records (needed for undo)
CREATE OR REPLACE FUNCTION restore_client(p_client_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE clients SET deleted_at = NULL
  WHERE id = p_client_id
    AND user_id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION restore_note(p_note_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE notes SET deleted_at = NULL
  WHERE id = p_note_id
    AND EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = notes.client_id
        AND clients.user_id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION restore_task(p_task_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE tasks SET deleted_at = NULL
  WHERE id = p_task_id
    AND EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = tasks.client_id
        AND clients.user_id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMIT;
