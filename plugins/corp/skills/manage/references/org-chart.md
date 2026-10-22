# Org chart

Each team has a **lead** (`corp:<team>-lead`) that plans and staffs a swarm of the shared workers `corp:scout` (reads code, runs tests, no web), `corp:web-scout` (web research, no shell) and `corp:builder` (edits). The corp guard hook enforces which workers each lead may dispatch. User-approved additions live in `~/.claude/corp/registry.md`.

## Levels

| Level | Model | Plans? | Typical work |
|---|---|---|---|
| Junior | haiku | **Never** | search, inventory, renames, boilerplate tests, collecting test output, summarizing reports |
| Normal | sonnet | Yes (minimum level that may plan) | implementation, careful review, research, leading light/medium work |
| Senior | opus | Yes (preferred planner) | architecture, threat models, plan integration, hard bugs, leading heavy work |

The manager picks each lead's level (sonnet or opus). Leads pick each worker's level (haiku or sonnet).

## Teams

| Team | Agent | Owns | Primary skills / tools |
|---|---|---|---|
| Architecture | `corp:architecture-lead` | system design, contracts, schema, ADRs | `agentic-sdlc:planning-from-spec`, `ponytail:ponytail`, `ponytail:ponytail-audit`, `simplify` |
| Security | `corp:security-lead` | threat models, design + diff review, privacy, supply chain, vetting third-party skills | `security-review`, `claude-security:claude-security` (if installed), `code-review` |
| Design / UX | `corp:design-lead` + Design studio session (`/corp:design-studio`) | visual design, UX flows, accessibility, design tokens | Emil Kowalski's skills (`emil-design-eng`, `animate`, `review-animations`, `apple-design`, `mobile-native`, `prototype`, `break-ui`), `taste-skill:design-taste-frontend`, `artifact-design`, Claude's Design artifact type, `expo:expo-design-system` |
| Planning | `corp:planning-lead` | the integrated plan and task specs | `agentic-sdlc:planning-from-spec`, `agentic-sdlc:generating-tasks`, `agentic-sdlc:reviewing-plan` |
| Development | `corp:dev-lead` | implementation, integration, tests | `agentic-sdlc:implementing-tasks`, `ponytail:ponytail`, `agentic-sdlc:testing-pytest`, `agentic-sdlc:testing-vitest`, `run` |
| QA | `corp:qa-lead` | independent verification against the plan | `agentic-sdlc:reviewing-code`, `code-review`, `run` |
| Talent (HR/CA) | `corp:talent-lead` (`/corp:hire`) | finding and ranking new skills, plugins, MCP servers | WebSearch, WebFetch, GitHub; Security vets every finalist |

A missing skill never blocks a team: it works from plain judgment and reports `missing skill: <name>`, which goes on Talent's list.
