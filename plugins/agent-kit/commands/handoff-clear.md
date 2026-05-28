---
allowed-tools: Bash
description: Delete .agents/handoff.md
---

# handoff-clear — delete session state

Remove `.agents/handoff.md`. Use when the handoff is stale, irrelevant, or you want to start fresh before the next `/handoff`.

## Workflow

1. **Check + delete** in one bash call:
   ```
   test -f .agents/handoff.md && rm .agents/handoff.md && echo "deleted .agents/handoff.md" || echo ".agents/handoff.md not present — nothing to do"
   ```
2. **Report** the result in one line. Stop.

## Rules

- Only touch `.agents/handoff.md`. Do not delete the `.agents/` directory or any other file.
- Never run without confirming the path matches `.agents/handoff.md`.
- Do not commit anything. `.agents/` is session state, not project state.
