#!/usr/bin/env bash
set -e
mkdir -p "$(dirname '.corp/board.md')"
cat > '.corp/board.md' <<'FIXTURE'
# Board: Users export their org's monthly report as CSV.

**Size:** heavy   **Started:** 2026-10-20   **Status:** planning
**Fix rounds:** 0/3

## Goal and definition of done
Users export their org's monthly report as CSV. Stack: Python FastAPI + Postgres.
- Feature works end to end with tests.
- Every security finding below is fixed or explicitly deferred with a reason.

## Contracts (frozen once approved; changes go through the manager)
- `GET /reports/{report_id}/export.csv -> 200 text/csv (streamed)`
- `def render_csv(rows: Iterable[ReportRow]) -> Iterator[str]`
Full design: docs/architecture/export-csv.md

## Decisions log
- 2026-10-21 Architecture approved by Security (manager)

## Open questions for the user
- none

## Teams
### Architecture
Status: done · Lead level: opus
Outputs: docs/architecture/export-csv.md
### Security
Status: done · Open findings: none blocking (all accepted into planning)
Findings to plan:
- S1 (high): Neutralize CSV formula injection: prefix cells starting with = + - @ with a single quote.
- S2 (high): Check the report belongs to the caller's org before export (IDOR).
- S3 (medium): Stream the response and cap exports at 100k rows.
### Design / UX
Status: not needed (no UI)
### Planning
Status: waiting
### Development
Status: waiting
### QA
Status: waiting
### Talent
Status: not needed
FIXTURE
mkdir -p "$(dirname 'docs/architecture/export-csv.md')"
cat > 'docs/architecture/export-csv.md' <<'FIXTURE'
# Architecture: export-csv

Users export their org's monthly report as CSV.

Stack: Python FastAPI + Postgres

## Contracts
- `GET /reports/{report_id}/export.csv -> 200 text/csv (streamed)`
- `def render_csv(rows: Iterable[ReportRow]) -> Iterator[str]`

## Existing code
- `app/routers/reports.py`
- `app/models.py`
- `tests/test_reports.py`
FIXTURE
mkdir -p "$(dirname 'app/routers/reports.py')"
cat > 'app/routers/reports.py' <<'FIXTURE'
from fastapi import APIRouter
router = APIRouter()
FIXTURE
mkdir -p "$(dirname 'app/models.py')"
cat > 'app/models.py' <<'FIXTURE'
# SQLAlchemy models: Org, Report, ReportRow
FIXTURE
mkdir -p "$(dirname 'tests/test_reports.py')"
cat > 'tests/test_reports.py' <<'FIXTURE'
def test_placeholder():
    assert True
FIXTURE
