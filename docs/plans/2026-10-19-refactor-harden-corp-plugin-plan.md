---
title: Harden the corp plugin (measure, bound, enforce, prove)
type: refactor
date: 2026-10-19
---

# Harden the corp plugin

> **Status (2026-10-19):** Phases 1–4 are implemented in v0.2.0. Gates G2a and G3 passed live (see [measurement-log.md](measurement-log.md)). Still open: G1, which needs real runs on your own repos; G2b/G2c (`--agent` and the desktop app); and the Phase 5 re-measurement. Unresolved decisions were taken at their defaults: `web-scout` split out, `talent-lead` Bash removed, cap of 3 rounds, Node hook.

## Overview

`corp` (v0.1.0) is a prompt-only plugin: a manager skill, 7 team-lead agents, 2 shared workers and a board. It works (one successful real use, plus end-to-end runs that produced the `911e997` fix), but nothing proves it keeps working, and most of its rules are prose the model may ignore. This plan makes it **trustworthy**, not bigger.

Scope is locked to **hardening only**. Nothing here adds a team, a dashboard or a new capability users see.

## Problem Statement

Weaknesses found by reading the whole repo (all file references are to the current tree). None has been observed failing in real use yet, so Phase 0 measures before anything changes.

| # | Weakness | Evidence |
|---|---|---|
| W1 | No tests, evals, validation or CI | `git ls-files`: no test files |
| W2 | Dev↔QA/Security fix loop has no cap; no cost ceiling | `manage/SKILL.md:645` ("until QA and Security pass") |
| W3 | Restart ignores an existing `.corp/board.md` | `manage/SKILL.md:660-664` has no resume step |
| W4 | Several leads edit one board file in parallel | `lead-protocol/SKILL.md:579-580` |
| W5 | Free-text lead reports; manager must parse prose | `lead-protocol/SKILL.md:582-591` |
| W6 | Safety rules are prose only: scouts have Bash + WebFetch together; `security-lead` has Edit/Write/builders; `talent-lead` has Bash | `scout.md:7`, `security-lead.md:7`, `talent-lead.md:7` |
| W7 | **New:** `Agent(corp:scout, corp:builder)` in a lead's `tools` is **not enforced** for subagents (docs: honoured only for a main-thread `--agent`). A lead can dispatch any agent type, including other leads, breaking "teams never dispatch each other" | sub-agents docs, see References |
| W8 | **New:** `initialPrompt` in `manager.md` is ignored for plugin agents | plugin manifest docs |
| W9 | Docs contradict each other: Design runs parallel with Architecture in `routing.md:843`, but strictly after Security in `manage/SKILL.md:641`; README says leads "run on Sonnet at minimum, Opus by default" while the manager overrides per dispatch | listed files |
| W10 | Packaging: `license: MIT` but no LICENSE file; no CHANGELOG; install docs show only a local Windows path | `plugin.json`, `README.md:34` |

## Proposed Solution

Five phases. Phase 0 is a gate: later phases proceed only on its results.

### Phase 0: Measure and validate gates (no behaviour changes)

Goal: replace inference with evidence.

- **0.1 Baseline checks.** Run `claude plugin validate . --strict --json` (needs v2.1.259+; we have 2.1.294) and record the output.
- **0.2 Measurement run.** Run 3–5 real tasks through `/corp:manage` (1 light, 2 medium, 1–2 heavy, at least one touching auth/dependencies) on repos you own. Record each in `docs/plans/measurement-log.md` using a fixed row: task, size chosen, teams dispatched, rounds of fix loop, board state, manager misparses, off-roster dispatches, tokens/time if visible, surprises.
- **0.3 Gates** (each ends with pass/fail written in the log):
  - **G1: do failures actually occur?** Which of W2–W9 appear in real runs. Reorders Phases 1–3 by observed pain.
  - **G2: nested dispatch.** Lead→worker with `run_in_background: false` works and waits, in (a) `/corp:manage` inside a normal session, (b) `claude --agent corp:manager`, (c) the desktop app. Also confirm W7 empirically (a lead can dispatch an off-roster agent) and W8 (`initialPrompt` ignored).
  - **G3: hook enforcement.** A throwaway PreToolUse hook that denies `Agent` calls blocks a lead's off-roster dispatch, and `agent_type` is populated inside a plugin subagent. Docs say yes; this proves it on our setup.

Exit: log committed; G2/G3 fail → fall back to prose-only rules plus evals (Phase 3 shrinks to tool trimming).

### Phase 1: Packaging and CI foundation

- Add `LICENSE` (MIT). Add `CHANGELOG.md`. Bump `plugin.json` to `0.2.0`, add `repository`, `homepage`, `license` fields.
- README: install from GitHub (`/plugin marketplace add Shaked-sz/claude-corp`, then `/plugin install corp@claude-corp`), keep the local-path variant as a dev note, document pinning (`owner/repo#v0.2.0`) as the rollback path.
- CI (`.github/workflows/ci.yml`): on every PR run `claude plugin validate . --strict --json`. No API cost.
- Add `.corp/` guidance to README (ignore or commit, user's choice).

### Phase 2: Contract fixes (text changes, all testable by evals)

1. **Fix-loop cap (W2).** `manage` §3 step 7: at most **3** rounds between Development and QA/Security. After round 3, stop, summarize open blockers, ask the user (continue / re-plan / accept with risk). Board gets a `Fix rounds: n/3` field.
2. **Resume (W3).** New `manage` step 0: if `.corp/board.md` exists, read its Status and ask the user: resume, archive (rename to `board-<date>.md`) and start fresh, or abandon. Never create a second board silently.
3. **Single board writer (W4).** Leads stop editing the board. Each lead's report carries a `BOARD UPDATE:` block; the **manager** applies it. The design-studio session does the same (report only). No locking needed.
4. **Strict report format (W5).** `lead-protocol` §8: one `KEY: value` per line at line start, fixed key order, `STATUS` enum, literal `none` for empty fields, plus the new `BOARD UPDATE:` key. Builder/scout formats unchanged.
5. **Routing consistency (W9).** Pick one rule and state it in both files: Design direction exploration may start in parallel with Architecture; Design's final output is checked against Architecture and Security before Planning.
6. **README model claims (W9).** "Each lead defaults to Opus; the manager sets Sonnet or Opus per dispatch."
7. **`manager.md` (W8).** Remove `initialPrompt` unless G2 shows it works for `--agent`; README tells users to type the goal after starting.

### Phase 3: Least privilege and enforcement

- **Split web access from execution (W6).** New worker `corp:web-scout` (Read, Glob, Grep, Skill, WebSearch, WebFetch; **no Bash**). `corp:scout` loses WebSearch/WebFetch and keeps Bash. Update the four leads that use web research (architecture, design, security, talent) to list both workers and brief web work to `web-scout`.
- **Trim leads.** `security-lead`: drop `Edit` and `corp:builder`, add "report, don't fix". `talent-lead`: drop `Bash` if G1/0.2 shows it is unused (Read/Glob cover the registry and installed-skill listing).
- **One hook script** `plugins/corp/hooks/guard.mjs` + `hooks/hooks.json`, PreToolUse, keyed on `agent_type` (only three rules, YAGNI):
  1. A lead may dispatch only `corp:scout`, `corp:web-scout`, `corp:builder` (per-lead subset; planning/qa/talent: scouts only). Fixes W7.
  2. Review roles (qa-lead, security-lead, scouts) may write only under `docs/` or `.corp/` (scouts: nowhere).
  3. Workers (scout, web-scout, builder) cannot run `git push`, `git commit`, package installs, or deploy commands. The dev-lead commits when the manager's brief says so.
  - On a hook crash the platform fails open (non-2 exit is non-blocking). Documented in the CHANGELOG; the eval covers a good path and the unit tests cover the deny paths.
  - File ownership between builders stays prose (the hook cannot see the brief).

### Phase 4: Evals and tests

Eval suite in `plugins/corp/evals/` (`claude plugin eval`), 6 cases, 3 runs each, threshold 0.8:

| Case | Proves | Grader types |
|---|---|---|
| `size-light` | "Fix README typo" dispatches no teams | llm, tool_used (absence checked via llm if unsupported) |
| `security-trigger-light` | Light change adding a dependency still gets Security | tool_used (`Agent`), llm |
| `routing-order` | Architecture → Security → Planning on a heavy goal | tool_order |
| `resume-board` | Existing board → asks resume/archive/abandon (scaffold script creates the board) | regex, llm |
| `fix-loop-cap` | With a history of 3 failed rounds, escalates to the user (history_file) | regex, llm |
| `report-format` | A lead report matches the strict format (line-start keys, STATUS enum) | regex |

Plus `node --test` unit tests for `guard.mjs` with fixture JSON (allowed and denied cases for each of the three rules, malformed input).

Eval notes from the platform docs: the eval sandbox contains only this plugin, so external skills are absent by design. That makes missing-skill degradation a free baseline check. Hooks are *outside* the eval sandbox, so hook behaviour is covered by unit tests, not evals. Bash-granting cases must run under WSL2 on Windows or in Linux CI; the 6 cases above avoid Bash.

CI: evals run on `workflow_dispatch` only, with `--trust-plugin --no-publish --max-cost-usd <cap> --threshold 0.8` and pinned `--model`/`--judge-model`. They never run on every PR because each run consumes model usage.

### Phase 5: Release and re-measure

Tag `v0.2.0`, update CHANGELOG, then repeat the Phase 0.2 task set and compare against the baseline log. Done means the Success Metrics below hold.

## Technical Considerations

- **Boring by default.** Everything uses documented platform features: `plugin validate`, `plugin eval`, PreToolUse hooks, plain markdown. The only novelty is the hook script, kept to ~3 rules.
- **Reversibility.** Every change is a text edit or an additive file. Rollback = pin the marketplace to `v0.1.0` (`#v0.1.0`) or the commit SHA; no data migrations.
- **Systems over heroes.** Rules move from "the model should remember" to "the hook denies it" or "the eval fails", so a stranger at 3am gets signal.
- **Complexity check.** Touches more than 8 files, but most edits are one to ten lines. New surfaces are only: 1 agent file, 1 hook script (+ test, + hooks.json), 6 eval cases, 3 packaging files, 1 workflow. No new services or classes.

## Architecture Diagram

```
user ─► /corp:manage (manager, SOLE board writer)
          │ 0. board exists? ─► ask: resume | archive | abandon      [new]
          │ dispatches leads (opus/sonnet)
          ▼
   lead ──► scout (Bash, no web)  ·  web-scout (web, no Bash)  ·  builder (edit)
     │  report: strict KEY: value + BOARD UPDATE  ──► manager applies to .corp/board.md
     ▼
   PreToolUse hook (guard.mjs, keyed on agent_type)
     ├─ lead→Agent: allowed worker types only        ─► deny / allow
     ├─ review roles & scouts: Write only docs/.corp   ─► deny / allow
     └─ workers: no push/commit/install/deploy        ─► deny / allow
   Shadow paths: hook crash → fail open (documented, unit-tested deny paths);
                 fix loop round 3 → escalate to user; missing skill → degrade + report
CI: PR → validate --strict ;  dispatch → plugin eval (capped)
```

## Test Diagram

| New codepath/flow | Test type | Happy | Failure | Edge |
|---|---|---|---|---|
| Sizing light → no teams | eval `size-light` | Y | Y (staffs teams) | Y (ambiguous goal) |
| Security-trigger override on light task | eval `security-trigger-light` | Y | Y (skipped) | N (deferred) |
| Architecture→Security→Planning order | eval `routing-order` | Y | Y (order broken) | N |
| Board resume/archive/abandon | eval `resume-board` | Y | N | Y (corrupt board: deferred to measurement) |
| Fix-loop cap at 3 | eval `fix-loop-cap` | Y | Y (4th round attempted) | N |
| Strict lead report | eval `report-format` | Y | Y (missing key) | Y (`none` literal) |
| Hook rule 1: lead dispatch roster | node unit test | Y | Y | Y (unknown agent_type) |
| Hook rule 2: write paths | node unit test | Y | Y | Y (path traversal `..`) |
| Hook rule 3: worker outward commands | node unit test | Y | Y | Y (chained `a && git push`) |
| Hook malformed stdin | node unit test | n/a | Y | Y |
| Manifest/frontmatter validity | CI `validate --strict` | Y | Y | N |
| Single board writer (no lead edits board) | grep check in CI on `lead-protocol` + agent files | Y | Y | N |

## Failure Modes

| Codepath | Failure mode | Test? | Handled? | User sees? |
|---|---|---|---|---|
| Fix loop | Never converges | Y (eval) | Y (cap 3) | Escalation question |
| Restart | Existing board ignored | Y (eval) | Y (ask) | Resume prompt |
| Board write | Two leads clobber each other | Y (CI grep) | Y (single writer) | n/a |
| Lead dispatch | Lead spawns off-roster agent | Y (unit) | Y (hook deny) | Denial reason |
| Hook | Script crashes → fails open | Y (unit covers deny paths) | Documented limitation | Silent: **accepted risk**, logged in CHANGELOG |
| Hook | Windows path / quoting breaks the script | N | N | Silent: mitigated by G3 on the real setup |
| Report | Missing key → manager misparse | Y (eval) | Y (manager rejects and re-asks) | Retry |
| Web scout | Prompt injection via page | N (cannot eval offline) | Partial: no Bash on that worker, prose rule | Silent: residual risk, documented |
| Eval suite | Noisy LLM graders flap | Y (3 runs, threshold 0.8) | Y | CI report |
| Eval cost | Runaway spend | n/a | Y (`--max-cost-usd`) | CI exit 2 |

No row is silent with no test and no handling except the two flagged accepted residual risks (hook crash fail-open; web-page injection). Both are documented, not hidden.

## Acceptance Criteria

### Functional
- [ ] `docs/plans/measurement-log.md` exists with ≥3 real runs and pass/fail for G1–G3 before Phase 1 starts.
- [ ] `claude plugin validate . --strict` exits 0.
- [ ] Fix loop stops after 3 rounds and asks the user.
- [ ] `/corp:manage` with an existing board asks resume/archive/abandon and never creates a second board.
- [ ] Only the manager writes `.corp/board.md`; leads and the studio return `BOARD UPDATE:`.
- [ ] Lead reports match the strict format.
- [ ] A lead dispatching an off-roster agent is denied by the hook.
- [ ] `scout` has no web tools; `web-scout` has no Bash; `security-lead` has no Edit/builder.
- [ ] LICENSE and CHANGELOG exist; `plugin.json` is `0.2.0`; README shows the GitHub install and the pin/rollback form.
- [ ] `routing.md` and `manage` agree on Design/Architecture ordering; README model wording matches behaviour.

### Quality gates
- [ ] Eval suite: all 6 cases ≥ 0.8 over 3 runs; unit tests green.
- [ ] CI runs validate on every PR; evals runnable via `workflow_dispatch` with a cost cap.

## Success Metrics

- Re-measurement run (Phase 5) shows zero: board duplicates, off-roster dispatches, uncapped loops, misparsed reports.
- Eval pass rate ≥ 0.8 across 3 consecutive suite runs.
- Hook unit tests block 100% of the fixture violations.

## Dependencies and Risks

- Claude Code ≥ 2.1.269 for `plugin eval` (have 2.1.294). Evals need API usage; cap it.
- Hooks, `initialPrompt` and nested dispatch behave per docs but are verified empirically in G2/G3. A failed gate shrinks Phase 3, not the whole plan.
- LLM-graded evals are noisy: use 3 runs, threshold 0.8, pinned models.
- Writing evals for orchestration across subagents may cost more than expected: start with the 6 cases and a low cap.
- Risk of over-hardening: the hook blocks legitimate work. Mitigation: 3 rules only, deny messages that say how to proceed.

## NOT in Scope

| Deferred | Why |
|---|---|
| New teams (DevOps, Docs, Data) | Adds untested surface; revisit after v0.2.0 |
| Status command, cost dashboard | Delighters, not hardening |
| Merging into `claude-corps` | Decision to revisit once corp is measured and stable |
| Public marketplace listing | Needs the release process proven first |
| Builder file-ownership enforcement | Hook cannot see the brief; prose rule stays |
| Injection evals for web pages | Needs mocks/recording; residual risk documented |
| Per-lead token budgets | No platform budget API found; revisit with measurement data |

## What Already Exists

| Sub-problem | Existing | Reuse? |
|---|---|---|
| Validation | `claude plugin validate --strict --json` | Use as is |
| Behaviour tests | `claude plugin eval` (prompt.md + graders) | Use as is, no custom harness |
| Report conformance | eval `regex` grader | Reuse, no checker script |
| Resume state | `.corp/board.md` (already holds Status) | Extend, no new store |
| Enforcement | Plugin `hooks/hooks.json` + `agent_type` in hook input | Use as is |
| Rollback | Marketplace `ref`/`sha`, `#tag` pinning | Use as is |

## Unresolved Decisions

- Split `web-scout` from `scout` vs only dropping web tools from `scout` — it matters because Talent needs broad web sweeps — **default: split** (one small agent file).
- Remove `talent-lead` Bash — matters if it needs `gh` — **default: remove, restore only if Phase 0 shows a need**.
- Fix-loop cap value — **default: 3**.
- Hook language — **default: Node** (v24 present locally; CI uses `actions/setup-node`). Reconsider if G3 shows trouble on Windows.
- Strict report format wording — **default: current keys plus `BOARD UPDATE:`**.
- `marketplace.json` owner is `marvisilsss`, the git remote is `Shaked-sz` — matters for install docs — **default: leave the owner field, use the remote in docs; fix if it is a typo**.

## Documentation Plan

README (install, pin/rollback, board ownership, `.corp/` guidance), CHANGELOG (0.2.0, hook fail-open note), `routing.md`/`manage`/`lead-protocol`/`board.md`/`design-studio` updates in Phase 2.

## Plan Review Summary
- Scope challenge: passed with 1 flag (file count >8; justified, mostly one-line edits; new surfaces capped)
- NOT in scope: 7 items deferred
- What already exists: 6 items mapped
- Architecture diagram: included
- Test diagram: 12 codepaths mapped, 3 gaps (unit/eval coverage deferred for corrupt board, Windows hook path, web injection)
- Interaction states: N/A — no UI scope
- Failure modes: 10 mapped, 0 CRITICAL GAPS (2 accepted residual risks, documented)
- Engineering review: 4 issues found (W7 unenforced `Agent(...)`, W8 `initialPrompt`, eval sandbox excludes hooks, hooks fail open), all addressed in the plan
- Design review: N/A — no UI scope
- Unresolved decisions: 6 open (all with defaults)

## References and Research

### Internal
- `plugins/corp/skills/manage/SKILL.md:641-664`, `plugins/corp/skills/lead-protocol/SKILL.md:559-591`, `plugins/corp/skills/manage/references/routing.md:839-846`, `plugins/corp/agents/{scout,security-lead,talent-lead,manager}.md` frontmatter, `README.md:19,34`.
- Prior fix commit `911e997` (lead/worker sync and staffing).

### External (Claude Code docs, fetched 2026-10-19)
- https://code.claude.com/docs/en/sub-agents.md (nesting depth 3; `Agent(type)` only for main-thread `--agent`)
- https://code.claude.com/docs/en/hooks.md (PreToolUse, `agent_type`, exit 2 / `permissionDecision: deny`)
- https://code.claude.com/docs/en/plugins/manifest-reference.md (plugin agents ignore hooks/mcpServers/permissionMode/initialPrompt)
- https://code.claude.com/docs/en/plugins/cli-reference.md (`plugin validate`)
- https://code.claude.com/docs/en/plugin-evals.md (`plugin eval`, sandbox, CI flags)
- https://code.claude.com/docs/en/plugins/marketplace-reference.md, https://code.claude.com/docs/en/plugins/install.md (pinning, GitHub install)
