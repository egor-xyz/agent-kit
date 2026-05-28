# handoff.md — canonical schema

`.agents/handoff.md` is the portable state artifact produced by `/agent-kit:handoff` and consumed by `/agent-kit:handoff-resume`. Must be readable cold by any agent on any tool. **Keep it brief.** Bullets, not prose. Skip empty sections.

## File location

- Default: `.agents/handoff.md` at repo root.
- Override: argument to either command.
- **Not committed.** Add `.agents/` to `.gitignore`.

## Header

First line:

```
_Generated: <ISO-8601 UTC>
```

Example: `_Generated: 2026-05-28T14:32:11Z_`

## Required sections (always present)

### `## Target`

One sentence: what the user wants from this work.

> Example: `Refactor auth middleware to use the new token store without breaking session cookies.`

### `## Current State`

3–5 lines:

- `Branch: <name>`
- `Last commit: <short-sha> <subject>`
- `Working tree: clean | dirty`
- `Tests: passing | failing | unknown`
- `Tool: <Claude Code | Cursor | Codex | …>`

### `## Next Step`

The exact command, file:line, or instruction. **Specific.**

> Good: `Run pytest tests/auth/test_login.py::test_expired_token. Assertion at line 42 expects 401, new flow returns 403. Decide which is right.`
>
> Bad: `Continue work.`

## Optional sections (omit heading entirely when empty)

Do NOT write the heading with "none" underneath. Skip the whole section.

### `## Files Under Work`

Table, only when 2+ files in flight:

| path | status | purpose |
| --- | --- | --- |
| `src/auth/middleware.py` | modified | swap Session → TokenStore |
| `tests/auth/test_login.py` | modified, failing | assertion at line 42 |

### `## Changes Made`

Bullets when work is partially done:

- `src/auth/middleware.py:authenticate()` — replaced `Session.get_user()` with `TokenStore.lookup(token)`.

### `## Attempts & Dead Ends`

Bullets with verbatim error string (inline backticks if one line, fenced block if multi-line):

- Tried `TokenStore.invalidate_all_for_user(uid)` → `AttributeError: 'TokenStore' object has no attribute 'invalidate_all_for_user'`.

### `## Open Questions`

Bullets only when unresolved:

- Should `logout` clear cookies even if token already invalid? Need product decision.

### `## Context Pointers`

Bullets only when external refs matter:

- PR #482 (depends on this work)
- Linear AUTH-123

## Rules

- No secrets. No user-absolute paths. No AI attribution.
- Bullets > prose.
- Quote errors verbatim.
- Specific Next Step.
- Skip empty sections.

## Why this schema

Each section answers a question the resuming agent will ask:

| Section | Question |
| --- | --- |
| Target | What does the user want? |
| Current State | Am I on the same ground? |
| Next Step | What is the very next action? |
| Files Under Work | Where to focus? |
| Changes Made | What's done — don't redo. |
| Attempts & Dead Ends | What's ruled out — don't repeat. |
| Open Questions | What needs a decision? |
| Context Pointers | Where else to look? |

Omitted optional sections = "nothing relevant here." Required sections always present = the spine of the handoff.
