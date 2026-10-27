---
type: llm
focus: { source: file, path: docs/plans/PLAN-invites.md }
---

The approved security findings are: S1 (Invite tokens must be single-use and expire after 72h; store only a hash of the token.), S2 (Rate-limit invite sends to 20 per org per hour.), S3 (Accept endpoint must return the same error for unknown and expired tokens (no enumeration).).

PASS if each one maps to a concrete task (with a test that would catch it) or to an explicit deferral with a reason. FAIL if any finding is missing or only mentioned vaguely.
