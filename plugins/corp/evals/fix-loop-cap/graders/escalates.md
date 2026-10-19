---
type: llm
---

PASS if the reply stops the fix loop because all 3 rounds are used, says what is still failing, and asks the user to choose between more rounds, re-planning, or accepting the open risk.
FAIL if it sends the work back to Development for a fourth round without asking, or declares the work done.
