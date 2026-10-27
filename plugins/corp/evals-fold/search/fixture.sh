#!/usr/bin/env bash
set -e
mkdir -p "$(dirname '.corp/board.md')"
cat > '.corp/board.md' <<'FIXTURE'
# Board: Full-text search over articles.

**Size:** heavy   **Started:** 2026-10-20   **Status:** planning
**Fix rounds:** 0/3

## Goal and definition of done
Full-text search over articles. Stack: Python Flask + Postgres + React.
- Feature works end to end with tests.
- Every security finding below is fixed or explicitly deferred with a reason.

## Contracts (frozen once approved; changes go through the manager)
- `GET /api/search?q=<text>&page=<n> -> 200 {results: [{id, title, snippet}], total}`
- `column articles.search_vector tsvector, GIN index`
Full design: docs/architecture/search.md

## Decisions log
- 2026-10-21 Architecture approved by Security (manager)

## Open questions for the user
- none

## Teams
### Architecture
Status: done · Lead level: opus
Outputs: docs/architecture/search.md
### Security
Status: done · Open findings: none blocking (all accepted into planning)
Findings to plan:
- S1 (high): Use parameterized queries with plainto_tsquery; never interpolate q.
- S2 (medium): Reject q longer than 200 characters with 400.
### Design / UX
Status: done · Studio session: closed · Decisions:
- D1: Search box debounced at 250 ms; states: idle, loading, results, no results, error.
### Planning
Status: waiting
### Development
Status: waiting
### QA
Status: waiting
### Talent
Status: not needed
FIXTURE
mkdir -p "$(dirname 'docs/architecture/search.md')"
cat > 'docs/architecture/search.md' <<'FIXTURE'
# Architecture: search

Full-text search over articles.

Stack: Python Flask + Postgres + React

## Contracts
- `GET /api/search?q=<text>&page=<n> -> 200 {results: [{id, title, snippet}], total}`
- `column articles.search_vector tsvector, GIN index`

## Existing code
- `server/articles.py`
- `web/src/SearchBox.tsx`
FIXTURE
mkdir -p "$(dirname 'server/articles.py')"
cat > 'server/articles.py' <<'FIXTURE'
# list_articles(), get_article()
FIXTURE
mkdir -p "$(dirname 'web/src/SearchBox.tsx')"
cat > 'web/src/SearchBox.tsx' <<'FIXTURE'
export function SearchBox() { return null }
FIXTURE
