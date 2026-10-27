---
type: llm
focus: { source: file, path: docs/plans/PLAN-webhooks.md }
---

The approved security findings are: S1 (Verify the Stripe-Signature header with the endpoint secret before parsing the body.), S2 (Make processing idempotent on event_id.), S3 (Read the endpoint secret from env STRIPE_WEBHOOK_SECRET; never log it.).

PASS if each one maps to a concrete task (with a test that would catch it) or to an explicit deferral with a reason. FAIL if any finding is missing or only mentioned vaguely.
