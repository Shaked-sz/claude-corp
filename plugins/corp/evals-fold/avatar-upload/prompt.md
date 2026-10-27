---
description: Planning step for "avatar-upload" (Django + S3). Compares the planning-lead agent with the folded planning skill.
tags: [planning-fold]
max_turns: 40
timeout_seconds: 1800
allowed_tools: [Read, Glob, Grep, Skill, Agent, Write, Edit]
---

/corp:manage Resume this work. Architecture, Security and Design are done and approved on the board. Run only the Planning step now. Write the plan to docs/plans/PLAN-avatar-upload.md with all task specs inside that one file. Then stop: don't start Development, QA or any later step, and don't edit product code. Reply with the plan path and its parallel tracks.
