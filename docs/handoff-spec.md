# handoff.md — canonical schema

The `handoff.md` file is the portable state artifact produced by `/handoff` and consumed by `/resume`. It must be readable cold by any agent on any tool. This document defines its required structure.

## File location

- Default: `./handoff.md` at the repository root.
- Override: argument to `/handoff` or `/resume`.
- **Not committed.** Add to `.gitignore` if the project doesn't already.

## Header

The very first line of the file must be:

```
_Generated: <ISO-8601 UTC timestamp>_
```

Example: `_Generated: 2026-05-28T14:32:11Z_`

## Required H2 sections, in order

### `## Target`

One sentence describing what the user ultimately wants from this session. Not what was done — what they want.

> Example: "Refactor the auth middleware to use the new token store without breaking existing session cookies."

### `## Current State`

Five lines minimum:

- `Branch: <name>`
- `Last commit: <short-sha> <subject>`
- `Working tree: clean | dirty`
- `Tests: passing | failing | unknown (<note>)`
- `Tool: <agent tool name>` (e.g. Claude Code, Cursor, Codex)

### `## Files Under Work`

Markdown table:

| path | status | one-line purpose |
| --- | --- | --- |
| `src/auth/middleware.py` | modified | swap legacy `Session` for `TokenStore` |
| `tests/auth/test_login.py` | modified, failing | assertion at line 42 needs update |

### `## Changes Made`

Bullets per file. Reference functions or line ranges when useful.

- `src/auth/middleware.py:authenticate()` — replaced `Session.get_user()` with `TokenStore.lookup(token)`.
- `src/auth/middleware.py:logout()` — added cleanup call.

### `## Attempts & Dead Ends`

What you tried, why it failed. Quote error output verbatim inside fenced blocks.

- Tried `TokenStore.invalidate_all_for_user(user_id)` — does not exist:
  ```
  AttributeError: 'TokenStore' object has no attribute 'invalidate_all_for_user'
  ```
- Tried bypassing the legacy session cookie — broke `tests/integration/test_cookie_compat.py::test_legacy_session`.

### `## Open Questions / Assumptions`

Bullets. Anything unresolved or assumed.

- Assumed `TokenStore.lookup` returns `None` for unknown tokens (not exception). Confirm against `docs/token-store.md`.
- Question: should `logout` clear cookies even if token already invalid? Need product decision.

### `## Next Step`

The exact command, file:line, or instruction to resume at. **Specific.**

> Good: "Run `pytest tests/auth/test_login.py::test_expired_token -v`. The assertion at line 42 expects `401` but the new flow returns `403`. Decide which is correct and update either the code or the test."
>
> Bad: "Continue work."

### `## Context Pointers`

Bullets. PRs, tickets, threads, prior handoffs, relevant docs. Empty list if none.

- PR #482 (depends on this work)
- Linear ticket AUTH-123
- Prior handoff: `handoff-2026-05-27.md` (renamed before clearing)

## Rules

- **No secrets.** Never write API keys, tokens, credentials.
- **No user-specific absolute paths.** Use repo-relative paths only.
- **No AI attribution.** Do not add "Generated with…" lines.
- **Quote errors verbatim.** Future-you will grep them.
- **Be specific in Next Step.** "Continue" is not a next step.

## Why this schema

Each section answers a question the resuming agent will ask:

| Section | Question it answers |
| --- | --- |
| Target | What does the user actually want? |
| Current State | Am I on the same ground as the previous agent? |
| Files Under Work | What should I focus on? |
| Changes Made | What's already done — don't redo it. |
| Attempts & Dead Ends | What's already been ruled out — don't repeat. |
| Open Questions | What still needs a decision? |
| Next Step | What is the very next action? |
| Context Pointers | Where else should I look? |

A section missing means the resuming agent will improvise — which is exactly what handoff is meant to prevent.
