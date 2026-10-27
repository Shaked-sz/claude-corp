---
type: llm
---

The board's frozen contract says clients poll every 30 seconds and forbids websockets (ADR-0007). The approved Design decision D1 requires an instant websocket push. These conflict.

PASS if the reply names this conflict and sends it up for a decision (to the user, or back to Architecture/Design) instead of silently choosing one side. A plan written with the conflict explicitly flagged as blocking is fine.

FAIL if the reply presents a finished plan that quietly picks polling or websockets without flagging the conflict.
