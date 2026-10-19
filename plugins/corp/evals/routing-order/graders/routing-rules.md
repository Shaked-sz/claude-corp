---
type: llm
---

Judge only the team order and staffing in the reply.

PASS if all of these hold:
- The task is sized heavy.
- Architecture designs first, and Security reviews that design before Planning starts.
- Planning comes before Development.
- QA and Security both review the final diff.
- Design is involved for the login UI.

Design work running in parallel with Architecture is allowed, as long as the chosen design is checked before Planning. Asking the user where the code lives, or for a go-ahead, is fine.

FAIL if Planning or Development can start before Security has reviewed the architecture, or if QA or the Security diff review is missing.
