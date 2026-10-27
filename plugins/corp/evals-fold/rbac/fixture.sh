#!/usr/bin/env bash
set -e
mkdir -p "$(dirname '.corp/board.md')"
cat > '.corp/board.md' <<'FIXTURE'
# Board: Org roles: admin, member, viewer.

**Size:** heavy   **Started:** 2026-10-20   **Status:** planning
**Fix rounds:** 0/3

## Goal and definition of done
Org roles: admin, member, viewer. Stack: Next.js App Router + Prisma.
- Feature works end to end with tests.
- Every security finding below is fixed or explicitly deferred with a reason.

## Contracts (frozen once approved; changes go through the manager)
- `enum Role { ADMIN MEMBER VIEWER }  // Membership.role Role @default(MEMBER)`
- `export async function requireRole(orgId: string, min: Role): Promise<Session>`
- `PATCH /api/orgs/:orgId/members/:userId  body {role} -> 200`
Full design: docs/architecture/rbac.md

## Decisions log
- 2026-10-21 Architecture approved by Security (manager)

## Open questions for the user
- none

## Teams
### Architecture
Status: done · Lead level: opus
Outputs: docs/architecture/rbac.md
### Security
Status: done · Open findings: none blocking (all accepted into planning)
Findings to plan:
- S1 (critical): Every mutating route handler calls requireRole server-side; the UI hiding buttons is not enforcement.
- S2 (medium): Log role changes to an audit table (actor, target, old, new, at).
- S3 (high): The last admin of an org cannot be demoted or removed.
### Design / UX
Status: done · Studio session: closed · Decisions:
- D1: Members page: role dropdown per row, disabled with a tooltip for the last admin; optimistic update with rollback on error.
### Planning
Status: waiting
### Development
Status: waiting
### QA
Status: waiting
### Talent
Status: not needed
FIXTURE
mkdir -p "$(dirname 'docs/architecture/rbac.md')"
cat > 'docs/architecture/rbac.md' <<'FIXTURE'
# Architecture: rbac

Org roles: admin, member, viewer.

Stack: Next.js App Router + Prisma

## Contracts
- `enum Role { ADMIN MEMBER VIEWER }  // Membership.role Role @default(MEMBER)`
- `export async function requireRole(orgId: string, min: Role): Promise<Session>`
- `PATCH /api/orgs/:orgId/members/:userId  body {role} -> 200`

## Existing code
- `prisma/schema.prisma`
- `app/api/projects/route.ts`
- `app/settings/members/page.tsx`
FIXTURE
mkdir -p "$(dirname 'prisma/schema.prisma')"
cat > 'prisma/schema.prisma' <<'FIXTURE'
model Membership { id String @id userId String orgId String }
FIXTURE
mkdir -p "$(dirname 'app/api/projects/route.ts')"
cat > 'app/api/projects/route.ts' <<'FIXTURE'
export async function POST() {}
FIXTURE
mkdir -p "$(dirname 'app/settings/members/page.tsx')"
cat > 'app/settings/members/page.tsx' <<'FIXTURE'
export default function Page() { return null }
FIXTURE
