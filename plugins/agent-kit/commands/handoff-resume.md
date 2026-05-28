---
description: Load handoff.md, verify git state, print next step, wait for user "go".
argument-hint: [optional path override, defaults to ./handoff.md]
allowed-tools: Bash, Read
---

# /handoff-resume — load session state

Your job: load the session state written by `/handoff`, verify the working tree matches what the previous session expected, and **stop**. Do not execute the next step until the user explicitly says "go" (or equivalent).

## Workflow

1. **Read `handoff.md`** at the repo root (or the path the user provided).
2. **Verify git state matches.** Run in parallel:
   - `git rev-parse --abbrev-ref HEAD`
   - `git log -1 --oneline`
   - `git status --short`
3. **Compare** the current branch, last commit, and dirty status against the `## Current State` section in `handoff.md`.
4. **Report** in this exact format:

   ```
   === RESUMING SESSION ===
   Target:    <one-line from ## Target>
   Branch:    <current> (handoff said: <handoff value>)  [MATCH | DRIFT]
   Last commit: <current> (handoff said: <handoff value>)  [MATCH | DRIFT]
   Dirty:     <current> (handoff said: <handoff value>)  [MATCH | DRIFT]

   Next step:
   <verbatim content of ## Next Step section>

   Open questions:
   <verbatim content of ## Open Questions / Assumptions, or "none">

   ⚠️  DRIFT DETECTED: <describe what differs>      ← only if any DRIFT above
   ```

5. **Stop.** Do not run any tool, edit any file, or take any action. Wait for the user to confirm with "go", "continue", "yes", or similar.

## Rules

- **Never auto-execute the next step.** The user must confirm. This is a hard gate.
- **Surface drift loudly.** If branch, commit, or dirty status differs from the handoff, the user needs to decide whether to stash, checkout, or proceed anyway.
- **Do not edit `handoff.md`** during resume. That is `/handoff`'s job.
- **If `handoff.md` is missing** or malformed (missing required H2 sections), say so plainly and stop.
