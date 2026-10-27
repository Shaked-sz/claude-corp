#!/usr/bin/env bash
set -e
mkdir -p "$(dirname '.corp/board.md')"
cat > '.corp/board.md' <<'FIXTURE'
# Board: Users upload a profile photo.

**Size:** heavy   **Started:** 2026-10-20   **Status:** planning
**Fix rounds:** 0/3

## Goal and definition of done
Users upload a profile photo. Stack: Django + S3.
- Feature works end to end with tests.
- Every security finding below is fixed or explicitly deferred with a reason.

## Contracts (frozen once approved; changes go through the manager)
- `POST /account/avatar  multipart field 'avatar' -> 302 to /account`
- `Profile.avatar_key: CharField(max_length=200, null=True)`
Full design: docs/architecture/avatar-upload.md

## Decisions log
- 2026-10-21 Architecture approved by Security (manager)

## Open questions for the user
- none

## Teams
### Architecture
Status: done · Lead level: opus
Outputs: docs/architecture/avatar-upload.md
### Security
Status: done · Open findings: none blocking (all accepted into planning)
Findings to plan:
- S1 (high): Validate the file by content sniffing (JPEG/PNG/WebP only), not by extension.
- S2 (high): Cap uploads at 2 MB before reading the whole body.
- S3 (medium): Strip EXIF metadata (location PII) before storing.
- S4 (low): Set long cache headers on the CDN for avatar objects.
Note: Security says S4 may be deferred if justified.
### Design / UX
Status: done · Studio session: closed · Decisions:
- D1: Circular 96px preview with a drag-and-drop zone; states: empty, uploading with progress, error with retry.
### Planning
Status: waiting
### Development
Status: waiting
### QA
Status: waiting
### Talent
Status: not needed
FIXTURE
mkdir -p "$(dirname 'docs/architecture/avatar-upload.md')"
cat > 'docs/architecture/avatar-upload.md' <<'FIXTURE'
# Architecture: avatar-upload

Users upload a profile photo.

Stack: Django + S3

## Contracts
- `POST /account/avatar  multipart field 'avatar' -> 302 to /account`
- `Profile.avatar_key: CharField(max_length=200, null=True)`

## Existing code
- `accounts/views.py`
- `accounts/models.py`
- `templates/accounts/profile.html`
FIXTURE
mkdir -p "$(dirname 'accounts/views.py')"
cat > 'accounts/views.py' <<'FIXTURE'
# profile views
FIXTURE
mkdir -p "$(dirname 'accounts/models.py')"
cat > 'accounts/models.py' <<'FIXTURE'
# class Profile(models.Model): user, display_name
FIXTURE
mkdir -p "$(dirname 'templates/accounts/profile.html')"
cat > 'templates/accounts/profile.html' <<'FIXTURE'
<!-- profile page -->
FIXTURE
