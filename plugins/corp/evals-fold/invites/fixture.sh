#!/usr/bin/env bash
set -e
mkdir -p "$(dirname '.corp/board.md')"
cat > '.corp/board.md' <<'FIXTURE'
# Board: Org admins invite teammates by email; invitees accept via a link.

**Size:** heavy   **Started:** 2026-10-20   **Status:** planning
**Fix rounds:** 0/3

## Goal and definition of done
Org admins invite teammates by email; invitees accept via a link. Stack: Node/Express API + React.
- Feature works end to end with tests.
- Every security finding below is fixed or explicitly deferred with a reason.

## Contracts (frozen once approved; changes go through the manager)
- `POST /api/orgs/:orgId/invites  body {email: string, role: 'member'|'admin'} -> 201 {inviteId}`
- `POST /api/invites/:token/accept -> 200 {orgId}`
- `table invites (id uuid pk, org_id uuid fk, email text, role text, token_hash text, expires_at timestamptz, accepted_at timestamptz null)`
Full design: docs/architecture/invites.md

## Decisions log
- 2026-10-21 Architecture approved by Security (manager)

## Open questions for the user
- none

## Teams
### Architecture
Status: done · Lead level: opus
Outputs: docs/architecture/invites.md
### Security
Status: done · Open findings: none blocking (all accepted into planning)
Findings to plan:
- S1 (high): Invite tokens must be single-use and expire after 72h; store only a hash of the token.
- S2 (medium): Rate-limit invite sends to 20 per org per hour.
- S3 (medium): Accept endpoint must return the same error for unknown and expired tokens (no enumeration).
### Design / UX
Status: done · Studio session: closed · Decisions:
- D1: Pending invites list in Org settings with states: empty, sending, sent, failed, expired; resend and revoke actions.
### Planning
Status: waiting
### Development
Status: waiting
### QA
Status: waiting
### Talent
Status: not needed
FIXTURE
mkdir -p "$(dirname 'docs/architecture/invites.md')"
cat > 'docs/architecture/invites.md' <<'FIXTURE'
# Architecture: invites

Org admins invite teammates by email; invitees accept via a link.

Stack: Node/Express API + React

## Contracts
- `POST /api/orgs/:orgId/invites  body {email: string, role: 'member'|'admin'} -> 201 {inviteId}`
- `POST /api/invites/:token/accept -> 200 {orgId}`
- `table invites (id uuid pk, org_id uuid fk, email text, role text, token_hash text, expires_at timestamptz, accepted_at timestamptz null)`

## Existing code
- `api/src/routes/orgs.js`
- `web/src/pages/OrgSettings.jsx`
- `api/src/db/schema.sql`
FIXTURE
mkdir -p "$(dirname 'api/src/routes/orgs.js')"
cat > 'api/src/routes/orgs.js' <<'FIXTURE'
// existing org routes
module.exports = require('express').Router();
FIXTURE
mkdir -p "$(dirname 'web/src/pages/OrgSettings.jsx')"
cat > 'web/src/pages/OrgSettings.jsx' <<'FIXTURE'
export default function OrgSettings() { return null }
FIXTURE
mkdir -p "$(dirname 'api/src/db/schema.sql')"
cat > 'api/src/db/schema.sql' <<'FIXTURE'
create table orgs (id uuid primary key, name text not null);
FIXTURE
