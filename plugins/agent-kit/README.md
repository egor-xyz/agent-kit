# agent-kit

> Portable workflows for coding agents. First workflow: session handoff via `.agents/handoff.md` — survives `/clear`, tool switches, and new chats.

## Purpose

Agent sessions are disposable. Work-in-progress shouldn't be. This plugin ships portable workflows that move state between sessions and tools. The first one is **session handoff**: two commands and a skill that dump and reload session state via a `.agents/handoff.md` file readable by any agent on any tool.

## Workflow

```
work...  →  /handoff  →  /clear  →  /handoff-resume  →  "go"  →  continue
```

## When to use

- Long-running task likely to outlast a single session.
- About to switch tools (Claude Code → Cursor → Codex …) mid-task.
- Context window getting tight and you need a clean restart.
- Handing the work to a teammate or another agent.

## When NOT to use

- Trivial single-shot tasks. `.agents/handoff.md` overhead exceeds the value.
- Tasks driven turn-by-turn by the user; they are the handoff.

## Commands

| Command | Purpose |
| --- | --- |
| `/handoff` | Dump current session state to `.agents/handoff.md` (auto-populates git state). |
| `/handoff-resume` | Read `.agents/handoff.md`, verify git state, print Target + Next Step, **wait for user "go"**. |

In tools without namespacing (Cursor, Codex, Gemini, Copilot) the commands are typed as `/handoff` and `/handoff-resume`.

## Skill

| Skill | Trigger |
| --- | --- |
| `auto-handoff` | Auto-triggers on long, risky, or session-spanning work to keep `.agents/handoff.md` fresh mid-flight. **Not a slash command** — no need to invoke manually. |

## Install

### Claude Code (native)

```
/plugin marketplace add egor-xyz/agent-kit
/plugin install agent-kit@egor-xyz
```

### Other tools (shell installer)

```bash
# one tool
curl -fsSL https://raw.githubusercontent.com/egor-xyz/agent-kit/main/install.sh | sh -s -- agent-kit --cursor

# multiple
curl -fsSL https://raw.githubusercontent.com/egor-xyz/agent-kit/main/install.sh | sh -s -- agent-kit --cursor --codex --gemini --copilot

# everything detected on the machine
curl -fsSL https://raw.githubusercontent.com/egor-xyz/agent-kit/main/install.sh | sh -s -- agent-kit --all
```

### Install matrix

| Tool | Target location | Native install |
| --- | --- | --- |
| Claude Code | plugin cache | `/plugin install agent-kit@egor-xyz` |
| Cursor | `~/.cursor/commands/` | shell installer |
| Codex | `~/.codex/prompts/` | shell installer |
| Gemini | `~/.gemini/commands/` | shell installer |
| Copilot | `.github/prompts/` (project) | shell installer |

## Example

```
You: refactor the auth middleware to use the new token store
Agent: <does 40 tool calls, hits a wall>
You: /handoff
Agent: wrote .agents/handoff.md — next step: fix the assertion in tests/auth/test_login.py:42

You: /clear
You: /handoff-resume
Agent: === RESUMING SESSION ===
       Target: refactor auth middleware to new token store
       Branch: refactor/auth (handoff said: refactor/auth) [MATCH]
       Next step: fix the assertion in tests/auth/test_login.py:42
       [waits]
You: go        ← any affirmative: "go", "yes", "continue", "ok"
Agent: <continues exactly where it stopped>
```

## Schema

See [`docs/handoff-spec.md`](../../docs/handoff-spec.md) for the canonical schema. Required H2 sections: Target, Current State, Files Under Work, Changes Made, Attempts & Dead Ends, Open Questions, Next Step, Context Pointers.

## License

MIT.
