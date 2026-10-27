---
type: llm
focus: { source: file, path: docs/plans/PLAN-expo-offline.md }
---

Judge the implementation plan file.

PASS only if all hold:
- Every task names the files it owns, its acceptance tests, what it depends on, and a level (junior, normal or senior).
- No file is owned by two tasks.
- Tasks are grouped into tracks, with contracts/schema first, then parallel tracks that touch disjoint files, then integration.
- A builder could carry out each task without making a design decision.

FAIL if any of these is missing.
