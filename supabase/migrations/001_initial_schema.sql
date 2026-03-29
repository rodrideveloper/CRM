-- ============================================================
-- CRM MVP - Initial Schema for Supabase
-- WhatsApp Sales Pipeline for Small Businesses (Argentina)
-- ============================================================

-- 1. ENUM: client_status (pipeline stages)
CREATE TYPE client_status AS ENUM (
  'new',
  'contacted',
  'interested',
  'negotiating',
  'closed_won',
  'closed_lost'
);

-- 2. TABLE: clients
CREATE TABLE clients (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name       TEXT NOT NULL,
  phone      TEXT,
  status     client_status NOT NULL DEFAULT 'new',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

-- 3. TABLE: notes
CREATE TABLE notes (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id  UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  content    TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

-- 4. TABLE: tasks
CREATE TABLE tasks (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id  UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  title      TEXT NOT NULL,
  due_date   TIMESTAMPTZ,
  completed  BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

-- ============================================================
-- 5. INDEXES
-- ============================================================

-- clients: filter by owner (multi-tenant) and status (pipeline)
CREATE INDEX idx_clients_user_id ON clients(user_id);
CREATE INDEX idx_clients_status  ON clients(status);
CREATE INDEX idx_clients_user_status ON clients(user_id, status) WHERE deleted_at IS NULL;

-- notes: filter by client
CREATE INDEX idx_notes_client_id ON notes(client_id) WHERE deleted_at IS NULL;

-- tasks: filter by client, pending tasks sorted by due date
CREATE INDEX idx_tasks_client_id ON tasks(client_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_tasks_pending   ON tasks(due_date, completed) WHERE deleted_at IS NULL AND completed = false;

-- search: name search (trigram would be better but this covers LIKE 'prefix%')
CREATE INDEX idx_clients_name ON clients(name text_pattern_ops) WHERE deleted_at IS NULL;

-- ============================================================
-- 6. TRIGGER: auto-update updated_at on row change
-- ============================================================

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_clients_updated_at
  BEFORE UPDATE ON clients
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_notes_updated_at
  BEFORE UPDATE ON notes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_tasks_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- 7. ROW LEVEL SECURITY (RLS)
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes   ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks   ENABLE ROW LEVEL SECURITY;

-- --------------------------------------------------------
-- CLIENTS: user can only access their own clients
-- --------------------------------------------------------

CREATE POLICY "clients_select" ON clients
  FOR SELECT TO authenticated
  USING ((SELECT auth.uid()) = user_id AND deleted_at IS NULL);

CREATE POLICY "clients_insert" ON clients
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "clients_update" ON clients
  FOR UPDATE TO authenticated
  USING ((SELECT auth.uid()) = user_id)
  WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "clients_delete" ON clients
  FOR DELETE TO authenticated
  USING ((SELECT auth.uid()) = user_id);

-- --------------------------------------------------------
-- NOTES: user can only access notes of their own clients
-- --------------------------------------------------------

CREATE POLICY "notes_select" ON notes
  FOR SELECT TO authenticated
  USING (
    deleted_at IS NULL
    AND EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = notes.client_id
        AND clients.user_id = (SELECT auth.uid())
        AND clients.deleted_at IS NULL
    )
  );

CREATE POLICY "notes_insert" ON notes
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = notes.client_id
        AND clients.user_id = (SELECT auth.uid())
        AND clients.deleted_at IS NULL
    )
  );

CREATE POLICY "notes_update" ON notes
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = notes.client_id
        AND clients.user_id = (SELECT auth.uid())
        AND clients.deleted_at IS NULL
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = notes.client_id
        AND clients.user_id = (SELECT auth.uid())
        AND clients.deleted_at IS NULL
    )
  );

CREATE POLICY "notes_delete" ON notes
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = notes.client_id
        AND clients.user_id = (SELECT auth.uid())
        AND clients.deleted_at IS NULL
    )
  );

-- --------------------------------------------------------
-- TASKS: user can only access tasks of their own clients
-- --------------------------------------------------------

CREATE POLICY "tasks_select" ON tasks
  FOR SELECT TO authenticated
  USING (
    deleted_at IS NULL
    AND EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = tasks.client_id
        AND clients.user_id = (SELECT auth.uid())
        AND clients.deleted_at IS NULL
    )
  );

CREATE POLICY "tasks_insert" ON tasks
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = tasks.client_id
        AND clients.user_id = (SELECT auth.uid())
        AND clients.deleted_at IS NULL
    )
  );

CREATE POLICY "tasks_update" ON tasks
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = tasks.client_id
        AND clients.user_id = (SELECT auth.uid())
        AND clients.deleted_at IS NULL
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = tasks.client_id
        AND clients.user_id = (SELECT auth.uid())
        AND clients.deleted_at IS NULL
    )
  );

CREATE POLICY "tasks_delete" ON tasks
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = tasks.client_id
        AND clients.user_id = (SELECT auth.uid())
        AND clients.deleted_at IS NULL
    )
  );
