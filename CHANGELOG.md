# Changelog

## 0.2.0 — 2026-10-19

Hardening release. No new teams; the existing org is now bounded, resumable and enforced.

### Added
- **Corp guard hook** (`hooks/guard.mjs`, PreToolUse). Rules are keyed on the calling agent:
  - Each lead may dispatch only its own workers. Before this, the `Agent(...)` list in a subagent's `tools` wasn't enforced, so any lead could dispatch any agent, including other leads.
  - Scouts never write. QA and Security write only under `docs/` or `.corp/`.
  - Workers can't commit, push, install, publish or deploy.
- **`corp:web-scout`** worker for web research, with no shell. `corp:scout` keeps the shell but loses web access, so no single worker reads untrusted pages *and* runs commands.
- **Eval suite** (`plugins/corp/evals/`, run with `claude plugin eval`) covering sizing, the security trigger, routing order, board resume, the fix-loop cap and the report format.
- Unit tests for the guard (`node --test plugins/corp/hooks/guard.test.mjs`).
- CI: `claude plugin validate --strict` and the guard tests on every push. Evals run on manual dispatch with a cost cap.
- LICENSE (MIT).

### Changed
- **Fix loop capped at 3 rounds.** After that the manager stops and asks you: continue, re-plan, or accept the named risks.
- **Board resume.** `/corp:manage` checks for an unfinished `.corp/board.md` and asks: resume, archive or abandon. It never starts a second board silently.
- **Single board writer.** Leads and the design studio send `BOARD UPDATE:` in their reports, and only the manager edits the board, so parallel leads can't overwrite each other.
- **Strict report format.** Every key starts its own line, empty fields are the literal `none`, and there's a new `BOARD UPDATE:` key. The manager sends malformed reports back.
- `security-lead` reviews and reports. It no longer has Edit or builders.
- `talent-lead` no longer has Bash.
- Design/Architecture ordering is now stated the same way in `manage` and `routing.md`.

### Fixed after an end-to-end run
A heavy multi-tenant SaaS build on a scratch app exercised every team, across three sessions and two crash-resumes.
- **The manager stopped ending its turn just to wait for leads.** In `claude -p` the CLI stops background agents 10 minutes after the last turn, which cut off Planning and then QA. Leads now go out in the foreground unless the manager has real work to do meanwhile. The README covers `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0` for headless runs.
- **The guard now denies a lead dispatching workers in the background.** The lead protocol already forbade it, and QA did it anyway.
- **QA, Security and scouts may write throwaway files in the OS temp folder.** These are probe scripts and mutation-testing copies. Project files stay off limits. This removes a false denial that blocked QA's mutation testing. Scouts get the Write tool so the guard can see the path, instead of scouts writing through shell redirects.
- **The manager replaces a team's board section on each update instead of appending,** so stale "Waiting on…" lines don't mislead a resumed run.

### Known limits
- The guard is a regex screen, not a shell parser. Unusual command forms can slip through, and the prose rules remain the second line.
- If the hook itself crashes (for example, `node` is missing), Claude Code treats that as non-blocking and the call goes through. The guard needs `node` on PATH.
- File ownership between builders is still a prose rule, because the hook can't see a lead's brief.

## 0.1.0 — 2026-10-18
Initial release.
