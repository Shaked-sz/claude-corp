#!/usr/bin/env bash
set -e
mkdir -p "$(dirname '.corp/board.md')"
cat > '.corp/board.md' <<'FIXTURE'
# Board: Add CSV export to the reports page

**Size:** medium   **Started:** 2026-10-17   **Status:** building
**Fix rounds:** 0/3

## Goal and definition of done
Add CSV export to the reports page. Done when export works end to end and QA passes.

## Contracts (frozen once approved; changes go through the manager)
GET /reports/:id/export.csv returns text/csv.

## Decisions log
- 2026-10-17 Medium size: Architecture, Development, QA (manager)

## Open questions for the user
- none

## Teams
### Architecture
Status: done · Lead level: sonnet
### Security
Status: not needed
### Design / UX
Status: not needed
### Planning
Status: done · Plan: docs/plans/PLAN-csv-export.md
### Development
Status: done · Tracks: api → sonnet → done
### QA
Status: working · Blockers: 0
### Talent
Status: not needed
FIXTURE
