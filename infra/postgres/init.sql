-- Initial schema for unified-reference-stack
-- Extend this file with application-specific tables.

CREATE TABLE IF NOT EXISTS health_log (
    id         SERIAL PRIMARY KEY,
    service    TEXT        NOT NULL,
    checked_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
