# Measurement log

Phase 0 and Phase 5 of [the hardening plan](2026-10-19-refactor-harden-corp-plugin-plan.md). The plan's weakness list came from reading the files, so record real runs here to show which failures actually happen.

## Gates

| Gate | Result | Evidence |
|---|---|---|
| G2a: nested dispatch, `claude -p` | **Pass** (2026-10-19) | Main session → `corp:planning-lead` (sonnet) → Agent call to `corp:builder`. The lead waited and reported in the lead-protocol format |
| G2b: nested dispatch, `claude --agent corp:manager` | **Pass** (2026-10-19) | Pantry run below. The manager loaded `corp:manage` through the Skill tool, because `initialPrompt` isn't needed. Leads spawned builders, and the guard saw the main thread as `corp:manager` and left it unrestricted |
| G2c: nested dispatch, desktop app | Not run yet | |
| G3: hook sees the calling agent and can block | **Pass** (2026-10-19) | Inside a subagent `agent_type` arrives as `corp:planning-lead`. The guard denied planning-lead → `corp:builder` and blocked a builder's `git push origin HEAD`, in a scratch repo with no remote. Both denial messages reached the agent verbatim |
| W7: `Agent(...)` list unenforced in subagents | **Confirmed** by the docs. Now enforced by the guard (G3 run) | |
| G1: do the inferred failures (W2–W9) happen in real runs? | **Needs your runs**, see below | |

## Eval suite results

| Date | Model | Runs | Result | Cost | Notes |
|---|---|---|---|---|---|
| 2026-10-19 | sonnet | 3 per case | 5/6 cases at 1.00; `report-format` 0.41 | $1.12 | The harness indents subagent reports by 2 spaces. The graders, and the manager's new "keys at line start" check, would both have rejected valid reports. Both fixed |
| 2026-10-19 | sonnet | 3 (`report-format`, `routing-order`) | 1.00 each | $0.37 | After the fix and a tighter `routing-order` rubric (Design running in parallel with Architecture is allowed) |

## End-to-end test: "Ledgerly" mega-project (2026-10-19, Claude-run)

A scratch zero-dependency invoicing API with deliberate weak spots: a shared API key with `==`, a stack-trace leak, mass assignment, no body limit, and a main check that fails on Windows. The heavy goal was multi-tenant orgs and roles, sessions, isolation, an audit log, CSV export, login rate limits and a members page, all run headless with defaults pre-approved.

| Run | What happened | Cost |
|---|---|---|
| 1 | Board check, then heavy sizing. Architecture and Design ran in parallel. Security blocked the design on 2 highs, Architecture revised twice, Security approved rev 3, and the contracts froze. Planning was cut off by the CLI's 10-minute background ceiling (**F1**) | (lost) |
| 2 | "Carry on": resumed at Planning only, after checking the disk. Planning wrote a 633-line plan. Dev ran 5 Sonnet builders plus a Haiku builder in parallel. Security's diff review found 2 mediums and 2 lows, including a real open redirect. QA was cut off by F1 again. A guard false positive hit QA's scratch script (**F2**), and QA backgrounded a scout (**F3**) | $12.58 |
| 3 | Resumed with the F1 fix. Every lead went out in the foreground. Fix round 1 closed all 4 findings; Security fuzzed them and re-reviewed. QA ran 93 live checks, a 13-attack cross-tenant probe and mutation testing, then fix round 2. 37/37 tests, done. Scouts needed scratch writes (**F4**) | $6.98 |
| claude-corps multi-review | 5 parallel specialist reviewers found **9 important issues** after corp passed. One was a regression from corp's own M-2 fix: the contract amendment turned "failed attempts" into "attempts" (**F5**) | $3.74 |
| 4 (with F1–F5 fixes) | Fed the review back in. The done board was archived and a new medium board opened. Dev fixed all 9 plus 8 informational items. Security's brief quoted the original requirement for each contract amendment; Security approved both and corrected the review where it was wrong ("4 IPs" is really 10). QA caught 13/15 mutations. 43/43 tests. Residual: the manager still backgrounded leads and waited, so the rule now names the "user is away / `-p`" case, and the README's env var covers headless runs | $4.16 |

Held throughout:
- Single board writer: 100% of board writes came from the manager.
- Architecture → Security → Planning order.
- Dispatch levels: no Haiku leads; Sonnet builders for features, Haiku for docs.
- Lead report format: every lead report passed.
- Guard rule 1: no off-roster dispatch was ever attempted.
- Resume, twice.

Fixes:
- **F1:** don't end the turn to wait for a lead; README documents the env var for headless runs.
- **F2 and F4:** temp-folder scratch writes for QA, Security and scouts, never inside the project.
- **F3:** the guard denies background worker dispatch.
- **F5:** heavy work gets an independent review by the manager; contract-amending fixes are re-checked against the original requirement; Security's abuse checklist now covers counters, key lengths and privilege overrides.
- Also, board team sections are now replaced on update rather than appended.

## `--agent` mode test: "Pantry" (2026-10-19, Claude-run)

A scratch recipe API with planted holes: a spoofable `x-user` header that also becomes a file path, no body limit, and error messages leaked on 500s. The heavy goal was photo uploads stored on disk, public share links with no login, revoke, and a share page. Run as `claude -p --agent corp:manager` with the README's headless env var. **$23.06, one session, 54/54 tests, board done, fix rounds 1/3.**

- **What every team did:**
  - **Architecture** found the path traversal and the EXIF/GPS leak unprompted.
  - **Security** blocked the design on 2 highs: a header spoof on all interfaces, and backslash or `%2e%2e` paths that route `/s/` to owner routes. Both were verified on this machine, along with a case-insensitive file mix-up on Windows.
  - **Design** produced 3 options and the recommended one was adopted.
  - **Planning** traced every requirement and finding, and wrote exact code for the junior tasks.
  - **Dev** followed the plan's levels: Sonnet for the security boundary, Haiku for transcribed tasks.
  - **QA** ran a real headless browser (16 screenshots), mutation-tested (35/36 caught) and probed planted EXIF data.
  - **Security** approved the code.
  - **The manager** ran the claude-corps independent review on the heavy diff (the F5 rule working), then did 1 fix round.
- **Held:**
  - All leads were dispatched in the foreground, under the "user is away" rule.
  - Only the manager wrote the board.
  - Every lead wrote only its own lane.
  - Review roles kept scratch files in temp (the F2 and F4 fix working).
  - Zero guard denials.
- **Deviations found and fixed:**
  - **F6:** after Security's design highs, the manager wrote the fix into the board contracts itself and never sent it back to Architecture. The design doc stayed "proposed", without H1/H2, and Planning had to reconcile two sources. Now: high design findings always go back to Architecture as a follow-up, and the manager never patches contracts itself.
  - **F7:** in `--agent` mode the manager calls the skill with no arguments, and the playbook said "empty goal → ask and stop". It carried on this time only by luck. Now an empty `$ARGUMENTS` means "take the goal from the conversation".

## Real runs (3–5, on your own repos)

Run `/corp:manage <goal>` on real work: 1 light task, 2 medium, 1–2 heavy, and at least one that touches auth or dependencies. Add one row per run.

| Date | Task | Size chosen | Teams dispatched | Fix rounds | Board OK? | Report misparses | Guard denials | Tokens/time | Surprises |
|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | |

Each guard denial is either a rule doing its job or a false positive. Note which, because false positives are what tune the guard.
