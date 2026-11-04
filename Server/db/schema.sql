-- OpenParliament — PostgreSQL schema
--
-- Normalised to third normal form: every repeated vocabulary item (party,
-- ministry, committee, session) lives in its own table and is referenced by
-- key. Derived figures (mean attendance, utilisation, totals) are never
-- stored; they are computed in the views at the bottom of this file.
--
-- Run with:  psql -d openparliament -f db/schema.sql

BEGIN;

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

-- MARK: - Vocabulary

CREATE TYPE house_name AS ENUM ('lok_sabha', 'rajya_sabha');
CREATE TYPE bill_stage AS ENUM ('introduced', 'committee', 'passed', 'enacted');
CREATE TYPE engagement_role AS ENUM ('sponsor', 'co_sponsor', 'committee_member', 'debated');

CREATE TABLE parties (
    abbreviation  TEXT PRIMARY KEY,
    name          TEXT NOT NULL UNIQUE
);

CREATE TABLE ministries (
    id    SERIAL PRIMARY KEY,
    name  TEXT NOT NULL UNIQUE
);

CREATE TABLE committees (
    id    SERIAL PRIMARY KEY,
    name  TEXT NOT NULL UNIQUE
);

-- Parliamentary sittings, oldest first by `ordinal`.
CREATE TABLE parliament_sessions (
    id           SERIAL PRIMARY KEY,
    ordinal      INTEGER NOT NULL UNIQUE,
    name         TEXT NOT NULL UNIQUE,      -- "Budget 2023"
    short_label  TEXT NOT NULL UNIQUE       -- "23B"
);

-- MARK: - Members

CREATE TABLE mps (
    id                  TEXT PRIMARY KEY,
    name                TEXT NOT NULL,
    constituency        TEXT NOT NULL,
    state               TEXT NOT NULL,
    party_abbreviation  TEXT NOT NULL REFERENCES parties (abbreviation),
    house               house_name NOT NULL,
    first_elected       INTEGER NOT NULL CHECK (first_elected BETWEEN 1952 AND 2100),
    questions_asked     INTEGER NOT NULL DEFAULT 0 CHECK (questions_asked >= 0)
);

CREATE TABLE mp_committees (
    mp_id         TEXT NOT NULL REFERENCES mps (id) ON DELETE CASCADE,
    committee_id  INTEGER NOT NULL REFERENCES committees (id),
    position      INTEGER NOT NULL DEFAULT 0,   -- display order on the profile
    PRIMARY KEY (mp_id, committee_id)
);

CREATE TABLE attendance_records (
    mp_id               TEXT NOT NULL REFERENCES mps (id) ON DELETE CASCADE,
    session_id          INTEGER NOT NULL REFERENCES parliament_sessions (id),
    attendance_percent  NUMERIC(5, 2) NOT NULL CHECK (attendance_percent BETWEEN 0 AND 100),
    PRIMARY KEY (mp_id, session_id)
);

-- MARK: - Legislation

CREATE TABLE bills (
    id           TEXT PRIMARY KEY,
    title        TEXT NOT NULL,
    bill_number  TEXT NOT NULL UNIQUE,      -- "Bill No. 118 of 2025"
    house        house_name NOT NULL,
    ministry_id  INTEGER NOT NULL REFERENCES ministries (id),
    stage        bill_stage NOT NULL,
    summary      TEXT NOT NULL
);

CREATE TABLE bill_key_points (
    bill_id   TEXT NOT NULL REFERENCES bills (id) ON DELETE CASCADE,
    position  INTEGER NOT NULL,
    point     TEXT NOT NULL,
    PRIMARY KEY (bill_id, position)
);

-- One dated row per stage a bill has reached.
CREATE TABLE bill_stage_events (
    bill_id     TEXT NOT NULL REFERENCES bills (id) ON DELETE CASCADE,
    stage       bill_stage NOT NULL,
    event_date  DATE NOT NULL,
    detail      TEXT NOT NULL,
    PRIMARY KEY (bill_id, stage)
);

CREATE TABLE bill_engagements (
    mp_id    TEXT NOT NULL REFERENCES mps (id) ON DELETE CASCADE,
    bill_id  TEXT NOT NULL REFERENCES bills (id) ON DELETE CASCADE,
    role     engagement_role NOT NULL,
    PRIMARY KEY (mp_id, bill_id, role)
);

-- A floor intervention. `bill_id` is NULL for zero hour, calling attention and
-- special mentions that are not tied to a bill.
CREATE TABLE speeches (
    id                TEXT PRIMARY KEY,
    mp_id             TEXT NOT NULL REFERENCES mps (id) ON DELETE CASCADE,
    bill_id           TEXT REFERENCES bills (id) ON DELETE SET NULL,
    topic             TEXT NOT NULL,
    spoken_on         DATE NOT NULL,
    duration_minutes  INTEGER NOT NULL CHECK (duration_minutes > 0),
    excerpt           TEXT NOT NULL
);

CREATE INDEX speeches_mp_idx ON speeches (mp_id, spoken_on DESC);
CREATE INDEX speeches_bill_idx ON speeches (bill_id, spoken_on DESC);

-- MARK: - Budget

CREATE TABLE schemes (
    id           TEXT PRIMARY KEY,
    name         TEXT NOT NULL UNIQUE,
    sector       TEXT NOT NULL,
    ministry_id  INTEGER NOT NULL REFERENCES ministries (id),
    summary      TEXT NOT NULL
);

CREATE TABLE fiscal_year_spend (
    scheme_id         TEXT NOT NULL REFERENCES schemes (id) ON DELETE CASCADE,
    label             TEXT NOT NULL,            -- "FY25"
    full_label        TEXT NOT NULL,            -- "2024–25"
    allocation_crore  NUMERIC(12, 2) NOT NULL CHECK (allocation_crore >= 0),
    actual_crore      NUMERIC(12, 2) NOT NULL CHECK (actual_crore >= 0),
    PRIMARY KEY (scheme_id, label)
);

-- At most one Comptroller and Auditor General observation per scheme.
CREATE TABLE cag_findings (
    scheme_id  TEXT PRIMARY KEY REFERENCES schemes (id) ON DELETE CASCADE,
    reference  TEXT NOT NULL,
    note       TEXT NOT NULL
);

-- Many-to-many: schemes that carry the spending a bill provides for.
CREATE TABLE bill_schemes (
    bill_id    TEXT NOT NULL REFERENCES bills (id) ON DELETE CASCADE,
    scheme_id  TEXT NOT NULL REFERENCES schemes (id) ON DELETE CASCADE,
    PRIMARY KEY (bill_id, scheme_id)
);

-- MARK: - Citizen activity

-- Bills a device has chosen to follow. The app identifies itself with an
-- anonymous per-install UUID; no personal data is stored.
CREATE TABLE bill_follows (
    device_id    UUID NOT NULL,
    bill_id      TEXT NOT NULL REFERENCES bills (id) ON DELETE CASCADE,
    followed_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (device_id, bill_id)
);

-- MARK: - Derived views

CREATE VIEW mp_attendance_summary AS
SELECT
    m.id AS mp_id,
    m.name,
    ROUND(AVG(a.attendance_percent), 1) AS mean_attendance,
    COUNT(a.*) AS sessions_recorded
FROM mps m
LEFT JOIN attendance_records a ON a.mp_id = m.id
GROUP BY m.id, m.name;

CREATE VIEW scheme_utilisation AS
SELECT
    s.id AS scheme_id,
    s.name,
    SUM(f.allocation_crore) AS total_allocation,
    SUM(f.actual_crore) AS total_actual,
    SUM(f.allocation_crore) - SUM(f.actual_crore) AS unspent,
    ROUND(100 * SUM(f.actual_crore) / NULLIF(SUM(f.allocation_crore), 0), 1) AS utilisation_percent
FROM schemes s
JOIN fiscal_year_spend f ON f.scheme_id = s.id
GROUP BY s.id, s.name;

CREATE VIEW bill_follower_counts AS
SELECT b.id AS bill_id, b.title, COUNT(f.device_id) AS followers
FROM bills b
LEFT JOIN bill_follows f ON f.bill_id = b.id
GROUP BY b.id, b.title;

COMMIT;
