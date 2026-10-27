#!/usr/bin/env bash
set -e
mkdir -p "$(dirname '.corp/board.md')"
cat > '.corp/board.md' <<'FIXTURE'
# Board: Notes that work offline and sync when back online.

**Size:** heavy   **Started:** 2026-10-20   **Status:** planning
**Fix rounds:** 0/3

## Goal and definition of done
Notes that work offline and sync when back online. Stack: Expo (React Native) + REST API.
- Feature works end to end with tests.
- Every security finding below is fixed or explicitly deferred with a reason.

## Contracts (frozen once approved; changes go through the manager)
- `PUT /api/notes/:id  body {text, updatedAt} -> 200 | 409 {serverNote}`
- `Conflict rule: last write wins by updatedAt; the losing local copy is kept as a conflicted duplicate.`
Full design: docs/architecture/expo-offline.md

## Decisions log
- 2026-10-21 Architecture approved by Security (manager)

## Open questions for the user
- none

## Teams
### Architecture
Status: done · Lead level: opus
Outputs: docs/architecture/expo-offline.md
### Security
Status: done · Open findings: none blocking (all accepted into planning)
Findings to plan:
- S1 (high): Encrypt the local notes database at rest with a key held in expo-secure-store.
### Design / UX
Status: done · Studio session: closed · Decisions:
- D1: Each note shows a sync status: synced, pending, conflicted. Conflicted notes get a banner with Keep mine / Keep theirs.
### Planning
Status: waiting
### Development
Status: waiting
### QA
Status: waiting
### Talent
Status: not needed
FIXTURE
mkdir -p "$(dirname 'docs/architecture/expo-offline.md')"
cat > 'docs/architecture/expo-offline.md' <<'FIXTURE'
# Architecture: expo-offline

Notes that work offline and sync when back online.

Stack: Expo (React Native) + REST API

## Contracts
- `PUT /api/notes/:id  body {text, updatedAt} -> 200 | 409 {serverNote}`
- `Conflict rule: last write wins by updatedAt; the losing local copy is kept as a conflicted duplicate.`

## Existing code
- `app/(tabs)/notes.tsx`
- `lib/api.ts`
FIXTURE
mkdir -p "$(dirname 'app/(tabs)/notes.tsx')"
cat > 'app/(tabs)/notes.tsx' <<'FIXTURE'
export default function Notes() { return null }
FIXTURE
mkdir -p "$(dirname 'lib/api.ts')"
cat > 'lib/api.ts' <<'FIXTURE'
export async function api(path: string) {}
FIXTURE
