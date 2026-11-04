#!/bin/sh
#
# Creates the local `openparliament` database (if needed), applies the schema
# and loads the seed data. Safe to re-run: the schema file drops and recreates
# everything, so this also resets the database to its seeded state.
#
set -eu

DB="${PGDATABASE:-openparliament}"
HERE="$(cd "$(dirname "$0")" && pwd)"

if ! psql -lqt | cut -d '|' -f 1 | grep -qw "$DB"; then
    echo "Creating database $DB"
    createdb "$DB"
fi

echo "Applying schema"
psql -q -v ON_ERROR_STOP=1 -d "$DB" -f "$HERE/schema.sql"

echo "Loading seed data"
psql -q -v ON_ERROR_STOP=1 -d "$DB" -f "$HERE/seed.sql"

echo "Done. $(psql -tA -d "$DB" -c 'SELECT COUNT(*) FROM mps') members, \
$(psql -tA -d "$DB" -c 'SELECT COUNT(*) FROM bills') bills, \
$(psql -tA -d "$DB" -c 'SELECT COUNT(*) FROM schemes') schemes loaded."
