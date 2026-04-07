-- ============================================================
-- Migration 008: Configurable pipeline stages
-- Stores per-user stage labels, visibility, and order as JSONB
-- ============================================================

ALTER TABLE user_profiles
  ADD COLUMN pipeline_config JSONB;

-- Default is NULL → app uses built-in defaults
-- Example value:
-- [
--   {"key": "new",         "label": "Nuevo",      "visible": true, "position": 0},
--   {"key": "contacted",   "label": "Contactado", "visible": true, "position": 1},
--   {"key": "interested",  "label": "Interesado", "visible": true, "position": 2},
--   {"key": "negotiating", "label": "Negociando", "visible": true, "position": 3},
--   {"key": "closed_won",  "label": "Ganado",     "visible": true, "position": 4},
--   {"key": "closed_lost", "label": "Perdido",    "visible": false,"position": 5}
-- ]
