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

**How the teams work:** each lead plans its part and runs a swarm of the shared workers `corp:scout` (read-only) and `corp:builder` (can edit). Workers never plan. Leads run on Sonnet at minimum, and on Opus by default.

**Routing the manager enforces:**
- Architecture → Security → Planning, always.
- Design reviews any UI work.
- Security reviews anything touching auth, data, payments or dependencies.
- QA and Security both review the final diff.

See `plugins/corp/skills/manage/references/routing.md` for the full matrix.

## Install

In an interactive `claude` terminal:

```
/plugin marketplace add C:\Users\User\Documents\claude-corp
/plugin install corp@claude-corp
```

To try it without installing:

```bash
claude --plugin-dir C:/Users/User/Documents/claude-corp/plugins/corp
```

## Use

- `/corp:manage <goal>`: run any goal through the manager. Light tasks skip the teams. Medium and heavy tasks get a `.corp/board.md` in your project.
- `claude --agent corp:manager`: start a session with the manager as the main agent.
- `/corp:design-studio <brief>`: live design session (the manager opens this for you when needed).
- `/corp:hire [team or gap]`: scout for new skills. Security vets each one, and you approve each install. Approved hires are recorded in `~/.claude/corp/registry.md`.

## Works best with

`taste-skill`, `agentic-sdlc`, `ponytail`, and the official `claude-security` plugin. Any missing skill is reported as a gap rather than breaking the flow.
