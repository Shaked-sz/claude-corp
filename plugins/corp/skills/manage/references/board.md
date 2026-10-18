# Board template

Copy into the project as `.corp/board.md` for medium and heavy work. The manager owns the top sections. Each lead edits only its own team section.

```markdown
# Board: <goal>

**Size:** <medium|heavy>   **Started:** <date>   **Status:** <planning|building|verifying|done>

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
