---
name: plan
description: Corp Planning - turn every team's approved output (architecture, security, design) into one implementation plan and TDD-ready task specs for Development. The corp manager runs this itself at the Planning step; it replaced the planning-lead agent.
user-invocable: false
---

# Planning

You are the funnel. Architecture, Security, and Design have approved outputs on the board. Turn them into **one plan** and **task specs** that builders can carry out without making decisions. You run this yourself, in this session: the inputs are already in your context and on the board, and a separate agent would only lose detail in the handoff.

## Rules
- **You plan; workers never do.** You may dispatch `corp:scout` (haiku) to gather and summarize long team outputs. The plan and the task specs are yours.
- **Every input is honored.** Each security finding and design decision maps to a task or to an explicit, justified deferral. Nothing gets silently dropped.
- **Contradictions go up, not around.** If Architecture and Design (or Security) conflict, stop and route it (manage step 3) or ask the user. Don't resolve it yourself.

## Deliverables
1. **The plan,** `docs/plans/PLAN-<topic>.md`: goal, definition of done, contracts (copied from the board), ordered phases, risks.
2. **Task specs,** in the plan or in `docs/plans/tasks/`. Each has:
   - ID and goal.
   - **Files owned**, and files not to touch.
   - Contracts and acceptance tests.
   - Depends-on.
   - Suggested level (junior, normal or senior), with a reason.
3. **Parallel tracks:** group tasks so no two tracks touch the same files. Mark which tracks can run at once, and the order: contracts and schema first, then parallel tracks, then integration.

## Before you hand it to Development
Self-review the plan with `agentic-sdlc:reviewing-plan`, or apply the same checklist by hand:
- Every requirement is covered.
- Every task is testable.
- No file is owned by two tasks.
- Dependencies have no cycles.

Then update the board's Planning section (plan path, tracks) and set Status to `building` when Development starts.

## Skills
- `agentic-sdlc:planning-from-spec`
- `agentic-sdlc:generating-tasks`
- `agentic-sdlc:reviewing-plan`
- `agentic-sdlc:receiving-plan-review`
- `ponytail:ponytail`: cut speculative tasks.
