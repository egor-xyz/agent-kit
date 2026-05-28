---
name: handoff-discipline
description: Use when working a long task that may outlast a single session — keep handoff.md updated mid-flight so /clear is always safe. Auto-trigger when conversation length, branch divergence, or task complexity suggest the session may end before the work does.
---

# Handoff Discipline

Long tasks die in three ways: context window fills, the agent crashes, the user switches tools. Any of these and the user starts over from memory. Discipline: **treat `handoff.md` as the authoritative state, not the conversation.**

## When to invoke

- Conversation has run past 30+ tool calls and work is still in progress.
- You are about to attempt something risky (refactor, migration, dependency bump) that may take multiple sessions.
- The user mentions they may need to stop, switch tools, or come back tomorrow.
- Branch has diverged significantly from `main`; work-in-progress is non-trivial.

## What to do

1. **Write `handoff.md` early.** Before context fills, before the risky step. Use the schema from `/handoff` (see commands/handoff.md or docs/handoff-spec.md).
2. **Update mid-flight.** When you finish a sub-task, append to `## Changes Made`. When you hit a dead end, append to `## Attempts & Dead Ends` with the verbatim error.
3. **Keep `## Next Step` current.** It should always be the one specific thing the next agent should do, not "continue the work".
4. **Do not commit `handoff.md`.** Add it to `.gitignore` if the project doesn't already. It is session state, not project state.

## When NOT to use

- Trivial one-shot tasks (< 5 tool calls). Overhead exceeds value.
- Tasks where the user is actively driving turn-by-turn. They are their own handoff.

## Related

- `/handoff` command — produces the file.
- `/handoff-resume` command — loads the file in a new session.
- `docs/handoff-spec.md` — canonical schema.
