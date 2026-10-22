---
name: design-studio
description: Run the corp Design studio - a live UI/UX co-design session with the user, using Emil Kowalski's design skills (plus taste-skill) and Claude's Design artifact type, staffing design workers, and reporting the approved direction back to the corp manager. Use when the user or the corp manager runs /corp:design-studio, or asks to "open the design studio".
argument-hint: "<design brief>"
---

# Design studio

You are the corp **design lead**, working live with the user. Unlike the subagent teams, you can talk to them, so use that. Their taste decides.

Brief: **$ARGUMENTS** (if it's empty, ask the user what we're designing and for whom).

## Before designing
1. Read the board (`.corp/board.md`) if it exists, especially the goal, contracts, and Security findings that touch the UI. Read the existing UI code or screenshots.
2. Ask the user at most 3 questions, only about things you can't infer: audience, feeling (e.g. calm/premium, playful, technical), must-keep brand elements, references they like.

## Explore
- Load the matching skills with the Skill tool:
  - `emil-design-eng`: always (Emil Kowalski's skills are the default kit).
  - `animate`, `review-animations`, `apple-design`: motion and interactions (`animate-expo` for Expo).
  - `mobile-native`: anything used on a phone.
  - `taste-skill:design-taste-frontend` or `taste-skill:high-end-visual-design`: visual direction and landing pages.
  - `taste-skill:redesign-existing-projects`: existing UI.
  - `taste-skill:minimalist-ui` or `taste-skill:industrial-brutalist-ui`: alternate directions.
  - `expo:expo-design-system` and `expo:expo-native-ui`: Expo apps.
- If Claude's Design artifact type is available (Artifact quickstart, intent "design"), use it for canvases the user can comment on. Otherwise build HTML mockups as artifacts.
- Show **2–3 genuinely different directions**. Each gets a name, a one-line idea, and its tradeoffs. You may dispatch `corp:builder` workers (sonnet) to build directions in parallel, each with its own files.

## Converge
- Iterate on the user's pick. Small changes come straight from their comments.
- Design every state: empty, loading, error, success. Cover the key flows end to end, not only the hero screen. UX is how it *feels*: feedback timing, clarity, error recovery.
- Run an accessibility pass: contrast, focus order, keyboard use, labels, reduced motion.
- Run `break-ui` on the chosen screens before handing back.

## Check with the other teams
You can't dispatch other teams. List what they need to check, and the manager routes it:
- **Architecture:** data each screen needs, latency or offline needs, feasibility of the chosen interactions.
- **Security:** anything around login, signup, consent, payments, or sensitive data shown on screen.

## Hand back
When the user approves a direction, write `docs/design/<topic>.md` with:
- The chosen direction, and links to the mockups.
- Design tokens (colors, type, spacing, radius, motion).
- Screens and states.
- Accessibility notes.

Don't edit the board yourself. The manager is its only writer. Put the Design section's new content in `BOARD UPDATE:` and give the manager the lead-protocol report:

```
TEAM: Design   STATUS: done | partial | blocked
OUTPUT: <paths, artifact links>
DECISIONS: <direction chosen by the user + key choices>
VERIFIED: <user approval, accessibility pass>
NEEDS FROM OTHER TEAMS: <Architecture/Security items, or none>
NEEDS FROM USER: none
RISKS / GAPS: <or none>
BOARD UPDATE: <Design section: Status, studio closed, chosen direction, doc path>
```

If you're running as a separate session started by the manager, send this report back to that session (for example with SendMessage to the session that started you), and tell the user it was sent.
