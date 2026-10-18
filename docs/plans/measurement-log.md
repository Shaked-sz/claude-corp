# Measurement log

Phase 0 and Phase 5 of [the hardening plan](2026-10-19-refactor-harden-corp-plugin-plan.md). The plan's weakness list came from reading the files, so record real runs here to show which failures actually happen.

## Gates

| Gate | Result | Evidence |
|---|---|---|
| G2a: nested dispatch, `claude -p` | **Pass** (2026-10-19) | Main session → `corp:planning-lead` (sonnet) → Agent call to `corp:builder`. The lead waited and reported in the lead-protocol format |
| G2b: nested dispatch, `claude --agent corp:manager` | Not run yet | |
| G2c: nested dispatch, desktop app | Not run yet | |
| G3: hook sees the calling agent and can block | **Pass** (2026-10-19) | Inside a subagent `agent_type` arrives as `corp:planning-lead`. The guard denied planning-lead → `corp:builder` and blocked a builder's `git push origin HEAD`, in a scratch repo with no remote. Both denial messages reached the agent verbatim |
| W7: `Agent(...)` list unenforced in subagents | **Confirmed** by the docs. Now enforced by the guard (G3 run) | |
| G1: do the inferred failures (W2–W9) happen in real runs? | **Needs your runs**, see below | |

## Eval suite results

| Date | Model | Runs | Result | Cost | Notes |
|---|---|---|---|---|---|
| 2026-10-19 | sonnet | 3 per case | 5/6 cases at 1.00; `report-format` 0.41 | $1.12 | The harness indents subagent reports by 2 spaces. The graders, and the manager's new "keys at line start" check, would both have rejected valid reports. Both fixed |
| 2026-10-19 | sonnet | 3 (`report-format`, `routing-order`) | 1.00 each | $0.37 | After the fix and a tighter `routing-order` rubric (Design running in parallel with Architecture is allowed) |

## Real runs (3–5, on your own repos)

Run `/corp:manage <goal>` on real work: 1 light task, 2 medium, 1–2 heavy, and at least one that touches auth or dependencies. Add one row per run.

| Date | Task | Size chosen | Teams dispatched | Fix rounds | Board OK? | Report misparses | Guard denials | Tokens/time | Surprises |
|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | |

Each guard denial is either a rule doing its job or a false positive. Note which, because false positives are what tune the guard.
