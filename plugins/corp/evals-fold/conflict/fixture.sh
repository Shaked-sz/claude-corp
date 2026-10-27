#!/usr/bin/env bash
set -e
mkdir -p "$(dirname '.corp/board.md')"
cat > '.corp/board.md' <<'FIXTURE'
# Board: In-app notifications with an unread badge.

**Size:** heavy   **Started:** 2026-10-20   **Status:** planning
**Fix rounds:** 0/3

## Goal and definition of done
In-app notifications with an unread badge. Stack: Node API + React.
- Feature works end to end with tests.
- Every security finding below is fixed or explicitly deferred with a reason.

## Contracts (frozen once approved; changes go through the manager)
- `GET /api/notifications?since=<iso8601> -> 200 [{id, kind, text, createdAt, readAt}]`
- `Clients poll GET /api/notifications every 30 seconds. No websockets or server push (decision ADR-0007: no long-lived connections on this infra).`
Full design: docs/architecture/conflict.md

## Decisions log
- 2026-10-21 Architecture approved by Security (manager)

## Open questions for the user
- none

## Teams
### Architecture
Status: done · Lead level: opus
Outputs: docs/architecture/conflict.md
### Security
Status: done · Open findings: none blocking (all accepted into planning)
Findings to plan:
- S1 (medium): Notifications are scoped to the requesting user; never accept a userId parameter.
### Design / UX
Status: done · Studio session: closed · Decisions:
- D1: The unread badge must update instantly when a notification arrives, via a websocket push channel; no polling delay is acceptable.
### Planning
Status: waiting
### Development
Status: waiting
### QA
Status: waiting
### Talent
Status: not needed
FIXTURE
mkdir -p "$(dirname 'docs/architecture/conflict.md')"
cat > 'docs/architecture/conflict.md' <<'FIXTURE'
# Architecture: conflict

In-app notifications with an unread badge.

Stack: Node API + React

## Contracts
- `GET /api/notifications?since=<iso8601> -> 200 [{id, kind, text, createdAt, readAt}]`
- `Clients poll GET /api/notifications every 30 seconds. No websockets or server push (decision ADR-0007: no long-lived connections on this infra).`

## Existing code
- `api/src/routes/index.js`
- `web/src/components/NavBar.jsx`
FIXTURE
mkdir -p "$(dirname 'api/src/routes/index.js')"
cat > 'api/src/routes/index.js' <<'FIXTURE'
// routes
FIXTURE
mkdir -p "$(dirname 'web/src/components/NavBar.jsx')"
cat > 'web/src/components/NavBar.jsx' <<'FIXTURE'
export default function NavBar() { return null }
FIXTURE
