---
description: Dump session state to handoff.md
argument-hint: [optional path override, defaults to ./handoff.md]
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
---

# /handoff — dump session state

Your job: capture everything a fresh agent needs to continue this work without re-reading the prior conversation. Write the result to `handoff.md` at the repository root (or the path the user provided as an argument).

## Workflow

1. **Gather git state.** Run in parallel:
   - `git rev-parse --abbrev-ref HEAD`
   - `git log -1 --oneline`
   - `git status --short`
   - `git diff --stat`
2. **Identify work in flight.** Files touched, what is done, what is pending. Use the conversation history plus `git status`.
3. **Recall dead ends.** Approaches you tried that did not work, with error messages quoted verbatim.
4. **Write `handoff.md`** matching the canonical schema below. Overwrite if it exists.
5. **Report:** print the absolute path to the file and a one-line summary of the next step.

## Schema (every section is required)

Header line: `_Generated: <ISO-8601 UTC timestamp>_`

Required H2 sections, in this order:

- `## Target` — one sentence: what the user ultimately wants from this session.
- `## Current State` — branch, last commit hash + subject, dirty/clean, test status if known.
- `## Files Under Work` — markdown table: `| path | status | one-line purpose |`.
- `## Changes Made` — bullets per file, function/line refs where useful.
- `## Attempts & Dead Ends` — what you tried, why it failed. Quote error output verbatim inside fenced blocks.
- `## Open Questions / Assumptions` — anything unresolved or assumed.
- `## Next Step` — the exact command, file:line, or instruction to resume at. Be concrete.
- `## Context Pointers` — relevant PRs, tickets, threads, prior handoffs. Empty bullet list if none.

## Rules

- **No secrets.** Never write API keys, tokens, or credentials into `handoff.md`.
- **No user-specific absolute paths.** Use repo-relative paths.
- **No AI attribution.** Do not add "Generated with …" lines.
- **Quote errors verbatim.** Future-you needs the exact string to grep.
- **Be specific in Next Step.** "Continue work" is not a next step. "Run `pytest tests/auth/test_login.py::test_expired_token` and fix the assertion at line 42" is.

After writing, do nothing else. Wait for the user to `/clear` and `/handoff-resume` in a new session.
