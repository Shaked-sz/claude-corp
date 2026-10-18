# Routing: who must work with whom

The teams don't know each other's fields. The manager does, and routes accordingly.

## Mandatory hand-offs

| When | From → To | Why |
|---|---|---|
| Any architecture design or contract | Architecture → **Security** | Architects aren't security experts: trust boundaries, auth, data storage, dependencies |
| Critical or high security finding on a design | Security → **Architecture** | Fix the design before anything gets planned |
| Any UI or UX work | → **Design** | How it looks and how it feels |
| Design direction chosen | Design → **Architecture** | Feasibility, data each screen needs, latency |
| Design touches login, signup, consent, payments, or sensitive data on screen | Design → **Security** | Auth-flow UX, privacy, dark-pattern and leak risks |
| All approved outputs ready | Architecture + Security + Design → **Planning** | One integrated plan, nothing dropped |
| Plan approved | Planning → **Development** | Builders execute task specs |
| Development reports done | Development → **QA** and **Security** (parallel) | Independent correctness + security diff review |
| QA blockers or security critical/high | QA / Security → **Development** | Fix loop, then re-review only what changed |
| A lead reports `missing skill:` | → **Talent** | Find a replacement |
| Talent finalists | Talent → **Security** → user | Vet before anyone may install |

## Security-review triggers (at every size, light included)

The change touches any of these:
- Auth or sessions.
- Permissions.
- User data or PII.
- Payments.
- File uploads.
- External APIs or webhooks.
- New dependencies.
- Secrets or config.
- Crypto.
- LLM or tool calls.

## Parallel vs sequential

| Can run in parallel | Must run in sequence |
|---|---|
| Design studio exploring directions while Architecture drafts, then reconcile both before Planning | Architecture → Security → Planning |
| QA + Security diff review | Planning → Development |
| Talent search, any time (it touches nothing) | Contract change → re-brief → resume |
| Development tracks with disjoint files | |

## Typical flows by size

| Size | Flow |
|---|---|
| Light | Manager or dev-lead only, plus a Security diff review if any trigger above applies. |
| Medium, backend | Architecture (sonnet) → Security if triggered → dev-lead → QA. |
| Medium, UI | Design → dev-lead → QA. |
| Heavy | Full flow (see the manage skill, step 3). |
