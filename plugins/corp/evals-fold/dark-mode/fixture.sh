#!/usr/bin/env bash
set -e
mkdir -p "$(dirname '.corp/board.md')"
cat > '.corp/board.md' <<'FIXTURE'
# Board: Add a light/dark theme toggle that follows the system setting by default.

**Size:** heavy   **Started:** 2026-10-20   **Status:** planning
**Fix rounds:** 0/3

## Goal and definition of done
Add a light/dark theme toggle that follows the system setting by default. Stack: React + CSS variables.
- Feature works end to end with tests.
- Every security finding below is fixed or explicitly deferred with a reason.

## Contracts (frozen once approved; changes go through the manager)
- `export type Theme = 'light' | 'dark' | 'system'`
- `export function useTheme(): { theme: Theme; setTheme(t: Theme): void }`
Full design: docs/architecture/dark-mode.md

## Decisions log
- 2026-10-21 Architecture approved by Security (manager)

## Open questions for the user
- none

## Teams
### Architecture
Status: done · Lead level: opus
Outputs: docs/architecture/dark-mode.md
### Security
Status: not needed (no security trigger in this change)
### Design / UX
Status: done · Studio session: closed · Decisions:
- D1: Toggle lives in the Header as a three-state segmented control: Light, Dark, System.
- D2: Dark palette tokens: --bg #0f1115, --fg #e7e9ee; contrast at least 4.5:1.
- D3: Persist the choice in localStorage; no flash of the wrong theme on load.
### Planning
Status: waiting
### Development
Status: waiting
### QA
Status: waiting
### Talent
Status: not needed
FIXTURE
mkdir -p "$(dirname 'docs/architecture/dark-mode.md')"
cat > 'docs/architecture/dark-mode.md' <<'FIXTURE'
# Architecture: dark-mode

Add a light/dark theme toggle that follows the system setting by default.

Stack: React + CSS variables

## Contracts
- `export type Theme = 'light' | 'dark' | 'system'`
- `export function useTheme(): { theme: Theme; setTheme(t: Theme): void }`

## Existing code
- `src/styles/tokens.css`
- `src/components/Header.tsx`
FIXTURE
mkdir -p "$(dirname 'src/styles/tokens.css')"
cat > 'src/styles/tokens.css' <<'FIXTURE'
:root { --bg: #fff; --fg: #111; }
FIXTURE
mkdir -p "$(dirname 'src/components/Header.tsx')"
cat > 'src/components/Header.tsx' <<'FIXTURE'
export function Header() { return null }
FIXTURE
