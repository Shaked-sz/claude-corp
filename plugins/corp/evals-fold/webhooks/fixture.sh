#!/usr/bin/env bash
set -e
mkdir -p "$(dirname '.corp/board.md')"
cat > '.corp/board.md' <<'FIXTURE'
# Board: Receive Stripe webhooks and mark invoices paid.

**Size:** heavy   **Started:** 2026-10-20   **Status:** planning
**Fix rounds:** 0/3

## Goal and definition of done
Receive Stripe webhooks and mark invoices paid. Stack: Go HTTP service.
- Feature works end to end with tests.
- Every security finding below is fixed or explicitly deferred with a reason.

## Contracts (frozen once approved; changes go through the manager)
- `POST /webhooks/stripe -> 200 on success, 400 on bad signature`
- `func (h *StripeHandler) Handle(w http.ResponseWriter, r *http.Request)`
- `table processed_events (event_id text primary key, processed_at timestamptz)`
Full design: docs/architecture/webhooks.md

## Decisions log
- 2026-10-21 Architecture approved by Security (manager)

## Open questions for the user
- none

## Teams
### Architecture
Status: done · Lead level: opus
Outputs: docs/architecture/webhooks.md
### Security
Status: done · Open findings: none blocking (all accepted into planning)
Findings to plan:
- S1 (critical): Verify the Stripe-Signature header with the endpoint secret before parsing the body.
- S2 (high): Make processing idempotent on event_id.
- S3 (medium): Read the endpoint secret from env STRIPE_WEBHOOK_SECRET; never log it.
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
mkdir -p "$(dirname 'docs/architecture/webhooks.md')"
cat > 'docs/architecture/webhooks.md' <<'FIXTURE'
# Architecture: webhooks

Receive Stripe webhooks and mark invoices paid.

Stack: Go HTTP service

## Contracts
- `POST /webhooks/stripe -> 200 on success, 400 on bad signature`
- `func (h *StripeHandler) Handle(w http.ResponseWriter, r *http.Request)`
- `table processed_events (event_id text primary key, processed_at timestamptz)`

## Existing code
- `cmd/server/main.go`
- `internal/billing/invoices.go`
FIXTURE
mkdir -p "$(dirname 'cmd/server/main.go')"
cat > 'cmd/server/main.go' <<'FIXTURE'
package main

func main() {}
FIXTURE
mkdir -p "$(dirname 'internal/billing/invoices.go')"
cat > 'internal/billing/invoices.go' <<'FIXTURE'
package billing

// MarkPaid(ctx, invoiceID) exists already
FIXTURE
