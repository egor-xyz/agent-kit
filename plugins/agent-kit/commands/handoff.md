---
description: Dump session state to handoff.md
argument-hint: [optional path override, defaults to ./handoff.md]
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
---

# /handoff — dump session state

Write a minimal `handoff.md` so a fresh agent can resume. **Be brief.** Bullets, not prose. Skip empty sections.

## Workflow

1. **Git state.** Single bash call, all in parallel:
   ```
   git rev-parse --abbrev-ref HEAD && git log -1 --oneline && git status --short
   ```
2. **Write `handoff.md`** using the schema below. Overwrite if exists.
3. **Report** the path and a one-line next-step summary. Stop.

## Schema

First line: `_Generated: <ISO-8601 UTC>_`

**Required** (always write):

- `## Target` — one sentence: what the user wants.
- `## Current State` — branch, last commit, dirty/clean.
- `## Next Step` — exact command or file:line. "Continue" is not a next step.

**Optional** (write only if non-empty; **omit the heading entirely if empty**):

- `## Files Under Work` — table `| path | status | purpose |` when 2+ files in flight.
- `## Changes Made` — bullets when work is partially done.
- `## Attempts & Dead Ends` — bullets with verbatim error string when something failed.
- `## Open Questions` — bullets when something is unresolved.
- `## Context Pointers` — bullets when PRs/tickets/threads matter.

## Rules

- No secrets. No absolute user paths. No AI attribution.
- Bullets > prose. Be terse.
- Quote errors verbatim (one line in backticks is fine; fenced block only if multi-line).
- Skip empty sections — don't write "none" or empty tables.

After writing, stop. Wait for `/clear` + `/agent-kit:handoff-resume`.
