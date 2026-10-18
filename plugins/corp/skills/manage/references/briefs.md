# Brief templates

A lead starts cold. If the brief doesn't say it, the lead doesn't know it.

## Manager → lead

```
TEAM: <team>            LEVEL: <sonnet|opus>      TASK SIZE: <light|medium|heavy>
GOAL: <one sentence: the outcome, not the steps>
SCOPE: <area/files this team owns>   DO NOT TOUCH: <other teams' files, frozen contracts>
CONTEXT: <facts you found, synthesized: relevant files, patterns to reuse, constraints, gotchas>
INPUTS FROM OTHER TEAMS: <quoted decisions/findings/contracts this team must honor, with file paths>
CONTRACTS: <frozen interfaces/schema, or "board: .corp/board.md#contracts">
DONE MEANS: <deliverables + how they'll be checked>
BOARD: <.corp/board.md, or "none (light task)">
USER-APPROVED OUTWARD ACTIONS: <e.g. "may commit to branch feat/x", or "none">
REPORT: lead-protocol report format.
```

Bad: "Review the auth stuff based on the findings above."
Good: "Review `docs/architecture/auth.md` (sessions via signed cookies, `POST /login`, users table with argon2 hashes) for the security checklist. Critical/high block Planning."

## Lead → worker

See lead-protocol section 4. Same idea, narrower:
- One task.
- Explicit file ownership.
- Skills to load.
- A check that proves it's done.

## Routing a cross-team need

When a lead's report has `NEEDS FROM OTHER TEAMS: Security: review the webhook signature check`:
- Dispatch Security with that need **quoted**.
- Add the files and contracts involved.
- Include the requesting team's relevant decisions.
- Name the requesting team, so the result gets routed back.
