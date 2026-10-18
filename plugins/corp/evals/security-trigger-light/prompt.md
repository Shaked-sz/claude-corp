---
description: A tiny change on a session/auth path still gets a Security diff review.
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill, Agent]
---

/corp:manage In auth.js, change the session cookie maxAge from 7 days to 30 days. Before doing any work, tell me your size and staffing in two lines, then stop and wait for my go-ahead. Don't dispatch anyone yet.
