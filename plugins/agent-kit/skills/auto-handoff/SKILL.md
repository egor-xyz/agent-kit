---
name: auto-handoff
description: Use when working a long task that may outlast a single session - keep .agents/handoff.md fresh mid-flight so /clear or a tool switch is always safe. Auto-triggers on ~30+ tool calls, before risky multi-session work, when user signals to stop or switch tools, or when branch has non-trivial WIP.
---

# auto-handoff

This is an **auto-trigger skill**, not a slash command. You don't type `/auto-handoff` — Claude reads this description and applies the behavior on its own when the conditions below match. The slash menu lists it only because Claude Code surfaces every installed skill as invokable; manual invocation works but is rarely needed.

Long tasks die in three ways: context window fills, the agent crashes, the user switches tools. Any of these and the user starts over from memory. **Treat `.agents/handoff.md` as the authoritative state, not the conversation.**

## Auto-trigger conditions

- Conversation has run past ~30 tool calls and work is still in progress.
- You are about to attempt something risky (refactor, migration, dependency bump) that may span multiple sessions.
- The user mentions they may need to stop, switch tools, or come back later.
- Branch has diverged significantly from `main`; work-in-progress is non-trivial.

## What to do when triggered

1. **Write `.agents/handoff.md` early.** Before context fills, before the risky step. Use the schema from `/handoff` (see [`commands/handoff.md`](../../commands/handoff.md) or [`docs/handoff-spec.md`](../../../../docs/handoff-spec.md)).
2. **Update mid-flight.** When you finish a sub-task, append to `## Changes Made`. When you hit a dead end, append to `## Attempts & Dead Ends` with the verbatim error.
3. **Keep `## Next Step` current.** It should always be the one specific thing the next agent should do, not "continue the work".
4. **Do not commit.** Add `.agents/` to `.gitignore` if the project doesn't already. Session state, not project state.

## When NOT to trigger

- Trivial one-shot tasks (< 5 tool calls). Overhead exceeds value.
- Tasks where the user is actively driving turn-by-turn. They are their own handoff.

## Related

- `/handoff` command — produces the file on demand.
- `/handoff-resume` command — loads the file in a new session.
- [`docs/handoff-spec.md`](../../../../docs/handoff-spec.md) — canonical schema.
