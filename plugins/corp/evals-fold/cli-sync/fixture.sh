#!/usr/bin/env bash
set -e
mkdir -p "$(dirname '.corp/board.md')"
cat > '.corp/board.md' <<'FIXTURE'
# Board: A `sync` command that uploads a local folder to an S3 bucket.

**Size:** heavy   **Started:** 2026-10-20   **Status:** planning
**Fix rounds:** 0/3

## Goal and definition of done
A `sync` command that uploads a local folder to an S3 bucket. Stack: Python CLI (click).
- Feature works end to end with tests.
- Every security finding below is fixed or explicitly deferred with a reason.

## Contracts (frozen once approved; changes go through the manager)
- `tool sync SRC_DIR s3://BUCKET/PREFIX [--dry-run] [--delete]`
- `def plan_sync(local: Path, remote: list[RemoteObject]) -> list[SyncOp]`
Full design: docs/architecture/cli-sync.md

## Decisions log
- 2026-10-21 Architecture approved by Security (manager)

## Open questions for the user
- none

## Teams
### Architecture
Status: done · Lead level: opus
Outputs: docs/architecture/cli-sync.md
### Security
Status: done · Open findings: none blocking (all accepted into planning)
Findings to plan:
- S1 (high): Never store AWS credentials in the tool config; use the standard AWS credential chain.
- S2 (high): Reject symlinks and paths that resolve outside SRC_DIR (path traversal).
- S3 (medium): --delete requires an interactive confirmation unless --yes is passed.
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
mkdir -p "$(dirname 'docs/architecture/cli-sync.md')"
cat > 'docs/architecture/cli-sync.md' <<'FIXTURE'
# Architecture: cli-sync

A `sync` command that uploads a local folder to an S3 bucket.

Stack: Python CLI (click)

## Contracts
- `tool sync SRC_DIR s3://BUCKET/PREFIX [--dry-run] [--delete]`
- `def plan_sync(local: Path, remote: list[RemoteObject]) -> list[SyncOp]`

## Existing code
- `tool/cli.py`
- `tool/config.py`
FIXTURE
mkdir -p "$(dirname 'tool/cli.py')"
cat > 'tool/cli.py' <<'FIXTURE'
import click

@click.group()
def cli():
    pass
FIXTURE
mkdir -p "$(dirname 'tool/config.py')"
cat > 'tool/config.py' <<'FIXTURE'
# reads ~/.tool/config.toml
FIXTURE
