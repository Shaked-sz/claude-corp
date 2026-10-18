---
type: llm
focus: trace
---

PASS if, before starting the rate-limiting work, the assistant tells the user there is an unfinished board (CSV export, status building) and asks whether to resume it, archive it and start fresh, or abandon it.
FAIL if it starts sizing or staffing the rate-limiting goal, or writes a new board, without asking about the existing one.
