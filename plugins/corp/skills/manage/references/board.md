# Board template

Copy into the project as `.corp/board.md` for medium and heavy work. **Only the manager writes it.** Leads and the design studio read it and send their section's changes in the `BOARD UPDATE:` field of their report. Whether `.corp/` is committed or git-ignored is the user's choice.

```markdown
# Board: <goal>

**Size:** <medium|heavy>   **Started:** <date>   **Status:** <planning|building|verifying|done|blocked|abandoned>
**Fix rounds:** <0/3>

## Goal and definition of done
<one paragraph + bullet list of what must be true>

## Contracts (frozen once approved; changes go through the manager)
<interfaces, endpoints, types, schema; or links to docs/architecture/...>

## Decisions log
- <date> <decision> (<who>, <why>)

## Open questions for the user
- <question> (<recommended answer>)

## Teams
### Architecture
Status: <not needed|waiting|working|done|blocked> · Lead level: <sonnet|opus>
Outputs: <paths>
### Security
Status: ... · Open findings: <critical/high/medium/low counts>
### Design / UX
Status: ... · Studio session: <open|closed|n/a> · Chosen direction: <name>
### Planning
Status: ... · Plan: <path> · Tracks: <list>
### Development
Status: ... · Tracks: <track → builder level → status>
### QA
Status: ... · Blockers: <count>
### Talent
Status: ... · Proposals awaiting user: <list>
```
