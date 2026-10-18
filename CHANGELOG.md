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

### Known limits
- The guard is a regex screen, not a shell parser. Unusual command forms can slip through, and the prose rules remain the second line.
- If the hook itself crashes (for example, `node` is missing), Claude Code treats that as non-blocking and the call goes through. The guard needs `node` on PATH.
- File ownership between builders is still a prose rule, because the hook can't see a lead's brief.

## 0.1.0 — 2026-10-18
Initial release.
