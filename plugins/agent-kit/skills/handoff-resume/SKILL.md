---
name: handoff-resume
description: Use when starting a session after handoff was run previously, to load .agents/handoff.md, verify git state, and wait for user confirm before acting
---

# handoff-resume — load session state

Invoked manually via `/handoff-resume` when the user wants to continue work captured by `/handoff` in a prior session. Load the state, verify the working tree matches, and **stop**. Do not execute the next step until the user explicitly says "go" (or equivalent).

## Workflow

1. **Read `.agents/handoff.md`** (or the path the user provided). If missing, fall back to `./handoff.md` for backwards compat; if still missing, say so and stop.
2. **Verify git state.** Single bash call, in parallel:
   ```
   git rev-parse --abbrev-ref HEAD && git log -1 --oneline && git status --short
   ```
3. **Compare** branch, last commit, dirty status against the `## Current State` section.
4. **Report** in this format:

   ```
   === RESUMING SESSION ===
   Target:    <one-line from ## Target>
   Branch:    <current> (handoff: <handoff value>)  [MATCH | DRIFT]
   Last commit: <current> (handoff: <handoff value>)  [MATCH | DRIFT]
   Dirty:     <current> (handoff: <handoff value>)  [MATCH | DRIFT]

   Next step:
   <verbatim content of ## Next Step>

   ⚠️  DRIFT DETECTED: <describe>      ← only if any DRIFT
   ```

5. **Stop.** No tool calls, no edits. Wait for user "go", "yes", "continue", or similar.

## Rules

- Never auto-execute the next step. Hard gate.
- Surface drift loudly.
- Do not edit `.agents/handoff.md` during resume.
- If file missing or required H2 sections missing (Target, Current State, Next Step), say so and stop.
