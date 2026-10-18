---
description: A lead's report follows the strict lead-protocol format, including BOARD UPDATE.
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill, Agent]
---

Use the Agent tool to dispatch corp:qa-lead with model "sonnet" and this brief:

TEAM: QA   LEVEL: sonnet   TASK SIZE: light
GOAL: Check whether README.md has an Install section.
SCOPE: README.md only.   DO NOT TOUCH: everything else.
DONE MEANS: you report whether the section exists, with the line it starts on.
BOARD: none (light task)
USER-APPROVED OUTWARD ACTIONS: none
Do it yourself; no scouts needed.

Then reply with the lead's report exactly as it came back, with nothing before or after it.
