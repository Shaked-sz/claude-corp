# claude-corp

A Claude Code plugin that turns Claude into the manager of an AI development organization. The manager sizes each task, staffs specialist teams at junior (Haiku), normal (Sonnet) or senior (Opus) level, routes work between teams that depend on each other, keeps a shared board, and checks every result before calling it done.

## The organization

| Team | Agent | Does |
|---|---|---|
| Manager | `/corp:manage` | Sizes, staffs, routes, verifies, and is the only one who talks to you |
| Architecture | `corp:architecture-lead` | Design, contracts, schema, ADRs |
| Security | `corp:security-lead` | Threat models, design and diff review, privacy, supply chain, vetting new skills |
| Design / UX | `corp:design-lead` + `/corp:design-studio` | Visual design and UX. Live co-design with you happens in a separate session |
| Planning | `corp:planning-lead` | Combines all team outputs into one plan and task specs |
| Development | `corp:dev-lead` | Builds the plan with parallel builders |
| QA | `corp:qa-lead` | Checks the work against the plan independently |
| Talent (HR) | `corp:talent-lead` / `/corp:hire` | Finds new skills, plugins and MCP servers. You approve every install |

**How the teams work:** each lead plans its part and runs a swarm of shared workers: `corp:scout` (reads code, runs tests, no web), `corp:web-scout` (web research, no shell) and `corp:builder` (edits its assigned files). Workers never plan. Leads default to Opus, and the manager picks Sonnet or Opus for each dispatch. Leads never run on Haiku.

**Routing the manager enforces:**
- Architecture → Security → Planning, always.
- Design reviews any UI work.
- Security reviews anything touching auth, data, payments or dependencies.
- QA and Security both review the final diff.

See `plugins/corp/skills/manage/references/routing.md` for the full matrix.

**Guardrails:**
- **Enforced by the guard hook** (`plugins/corp/hooks/guard.mjs`, needs `node` on PATH):
  - Each lead may dispatch only its own workers.
  - QA and Security write only under `docs/` or `.corp/`.
  - Scouts never write.
  - Workers can't commit, push, install or deploy.
- **Enforced by the manager:**
  - The fix loop between Development and QA/Security stops after 3 rounds and asks you.
  - An unfinished board is resumed, archived or abandoned, never silently duplicated.
  - Only the manager writes the board.

## Install

In an interactive `claude` terminal:

```
/plugin marketplace add Shaked-sz/claude-corp
/plugin install corp@claude-corp
```

To pin a release, or roll back to one, add the tag: `/plugin marketplace add Shaked-sz/claude-corp#v0.2.0`.

To try a local checkout without installing:

```bash
claude --plugin-dir ./plugins/corp
```

## Use

- `/corp:manage <goal>`: run any goal through the manager. Light tasks skip the teams. Medium and heavy tasks get a `.corp/board.md` in your project. Commit it or add `.corp/` to `.gitignore`, whichever you prefer. Run `/corp:manage` again after a crash or restart and it offers to resume.
- `claude --agent corp:manager`: start a session with the manager as the main agent, then type your goal.
- Headless (`claude -p "/corp:manage <goal>"`): set `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0`. Otherwise the CLI stops background agents 10 minutes after the manager's last turn, and a long lead gets cut off.
- `/corp:design-studio <brief>`: live design session (the manager opens this for you when needed).
- `/corp:hire [team or gap]`: scout for new skills. Security vets each one, and you approve each install. Approved hires are recorded in `~/.claude/corp/registry.md`.

## Works best with

`taste-skill`, `agentic-sdlc`, `ponytail`, and the official `claude-security` plugin. Any missing skill is reported as a gap rather than breaking the flow.

## Develop

```bash
claude plugin validate . --strict
claude plugin validate plugins/corp --strict
node --test plugins/corp/hooks/guard.test.mjs
cd plugins/corp && claude plugin eval . --scaffold --trust-plugin --ablation none --runs 1 --max-cost-usd 5
```

Evals use model credits, which is why CI runs them only on manual dispatch. See `CHANGELOG.md` for what changed in each release.
