---
type: llm
focus: { source: file, path: docs/plans/PLAN-dark-mode.md }
---

The approved design decisions are: D1 (Toggle lives in the Header as a three-state segmented control: Light, Dark, System.), D2 (Dark palette tokens: --bg #0f1115, --fg #e7e9ee; contrast at least 4.5:1.), D3 (Persist the choice in localStorage; no flash of the wrong theme on load.).

PASS if each is implemented by a task with a concrete acceptance check. FAIL if any is missing.
