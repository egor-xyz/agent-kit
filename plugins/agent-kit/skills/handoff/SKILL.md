---
name: handoff
description: Use when ending a session with work still in flight - dump session state to .agents/handoff.md (target, git state, files, changes, dead ends, next step) so any agent on any tool can resume cold after /clear, a tool switch, or a new chat.
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
---

# handoff — dump session state

Invoked manually via `/handoff` when the user wants to checkpoint, or auto-invoked when this description matches their intent. Write a minimal `.agents/handoff.md` so a fresh agent can resume. **Be brief.** Bullets, not prose. Skip empty sections. Create `.agents/` if it doesn't exist.

## Workflow

1. **Git state.** Single bash call, all in parallel:
   ```
   git rev-parse --abbrev-ref HEAD && git log -1 --oneline && git status --short
   ```
2. **Write `.agents/handoff.md`** using the schema below. `mkdir -p .agents` first. Overwrite if it exists.
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

- No secrets. No user-absolute paths. No AI attribution.
- Bullets > prose. Be terse.
- Quote errors verbatim (inline backticks if one line; fenced block only if multi-line).
- Skip empty sections — don't write "none" or empty tables.

After writing, stop. Wait for `/clear` + `/handoff-resume`.
