---
type: llm
focus: { source: file, path: docs/plans/PLAN-avatar-upload.md }
---

The approved security findings are: S1 (Validate the file by content sniffing (JPEG/PNG/WebP only), not by extension.), S2 (Cap uploads at 2 MB before reading the whole body.), S3 (Strip EXIF metadata (location PII) before storing.), S4 (Set long cache headers on the CDN for avatar objects.).

PASS if each one maps to a concrete task (with a test that would catch it) or to an explicit deferral with a reason. FAIL if any finding is missing or only mentioned vaguely.
