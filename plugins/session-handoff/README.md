# session-handoff

> Dump and resume agent session state via `handoff.md`. Survives `/clear`, tool switch, or new chat.

## Purpose

Agent sessions are disposable. Work-in-progress shouldn't be. This plugin ships two commands and one skill so that any long task ends with a portable state file (`handoff.md`) that any agent (same tool or different) can pick up cold.

## Workflow

```
work...  →  /handoff  →  /clear  →  /handoff-resume  →  confirm  →  continue
```

## When to use

- Long-running task likely to outlast a single session.
- About to switch tools (Claude Code → Cursor → Codex …) mid-task.
- Context window getting tight and you need a clean restart.
- Handing the work to a teammate or another agent.

## When NOT to use

- Trivial single-shot tasks. `handoff.md` overhead exceeds the value.
- Tasks driven turn-by-turn by the user; they are the handoff.

## Commands

| Command | Purpose |
| --- | --- |
| `/handoff` | Dump current session state to `handoff.md` (auto-populates git state). |
| `/handoff-resume` | Read `handoff.md`, verify git state, print Target + Next Step, **wait for user "go"**. |

## Skill

| Skill | Trigger |
| --- | --- |
| `handoff-discipline` | Auto-triggers on long tasks; reminds the agent to keep `handoff.md` updated mid-flight. |

## Install

### Claude Code (native)

```
/plugin marketplace add egor-xyz/agent-kit
/plugin install session-handoff@agent-kit
```

### Other tools (shell installer)

```bash
# one tool
curl -fsSL https://raw.githubusercontent.com/egor-xyz/agent-kit/main/install.sh | sh -s -- session-handoff --cursor

# multiple
curl -fsSL https://raw.githubusercontent.com/egor-xyz/agent-kit/main/install.sh | sh -s -- session-handoff --cursor --codex --gemini --copilot

# everything detected on the machine
curl -fsSL https://raw.githubusercontent.com/egor-xyz/agent-kit/main/install.sh | sh -s -- session-handoff --all
```

### Install matrix

| Tool | Target location | Native install |
| --- | --- | --- |
| Claude Code | `~/.claude/commands/` (or plugin cache) | `/plugin install session-handoff@agent-kit` |
| Cursor | `~/.cursor/commands/` | shell installer |
| Codex | `~/.codex/prompts/` | shell installer |
| Gemini | `~/.gemini/commands/` | shell installer |
| Copilot | `.github/prompts/` (project) | shell installer |

## Example

```
You: refactor the auth middleware to use the new token store
Agent: <does 40 tool calls, hits a wall>
You: /handoff
Agent: wrote handoff.md — next step: fix the assertion in tests/auth/test_login.py:42

You: /clear
You: /handoff-resume
Agent: === RESUMING SESSION ===
       Target: refactor auth middleware to new token store
       Branch: refactor/auth (handoff said: refactor/auth) [MATCH]
       Next step: fix the assertion in tests/auth/test_login.py:42
       [waits]
You: go
Agent: <continues exactly where it stopped>
```

## handoff.md schema

See [`docs/handoff-spec.md`](../../docs/handoff-spec.md) for the canonical schema. Required H2 sections: Target, Current State, Files Under Work, Changes Made, Attempts & Dead Ends, Open Questions, Next Step, Context Pointers.

## License

MIT.
