<h1 align="center">agent-kit</h1>

<p align="center"><b>Portable workflows for coding agents.</b><br/>
Skills, commands, hooks, and configs that survive tool switches.</p>

<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-✓-7C3AED?style=flat-square" alt="Claude Code">
  <img src="https://img.shields.io/badge/Cursor-✓-000000?style=flat-square" alt="Cursor">
  <img src="https://img.shields.io/badge/Codex-✓-10A37F?style=flat-square" alt="Codex">
  <img src="https://img.shields.io/badge/Gemini-✓-4285F4?style=flat-square" alt="Gemini">
  <img src="https://img.shields.io/badge/Copilot-✓-24292E?style=flat-square" alt="Copilot">
  <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="MIT">
</p>

---

> Your agent session dies. Your work shouldn't. **agent-kit** ships portable workflows — starting with `/agent-kit:handoff` + `/agent-kit:handoff-resume` — that move state between sessions and tools.

## Demo

```
you:    refactor auth middleware to use new token store
agent:  <40 tool calls, hits a wall>
you:    /agent-kit:handoff              ←  dump state
you:    /clear                          ←  wipe context
you:    /agent-kit:handoff-resume       ←  load state, no re-explaining
agent:  === RESUMING SESSION ===
        Target: refactor auth middleware to new token store
        Branch: refactor/auth [MATCH]
        Next step: fix assertion in tests/auth/test_login.py:42
        [waits]
you:    go                              ←  any affirmative: "go", "yes", "continue"
agent:  <continues exactly where it stopped>
```

Same workflow, any tool. `/handoff` in Claude Code → `/clear` → switch to Cursor → `/handoff-resume`. Same `.agents/handoff.md`, same state.

## Install

### Claude Code (native — recommended)

```
/plugin marketplace add egor-xyz/agent-kit
/plugin install agent-kit@egor-xyz
```

Then invoke as `/agent-kit:handoff` and `/agent-kit:handoff-resume`.

### Any other tool (one line)

```bash
curl -fsSL https://raw.githubusercontent.com/egor-xyz/agent-kit/main/install.sh | sh -s -- agent-kit --cursor
```

Replace `--cursor` with any of `--codex`, `--gemini`, `--copilot`, `--claude`, or `--all`. Combine flags to install everywhere at once:

```bash
curl -fsSL .../install.sh | sh -s -- agent-kit --cursor --codex --gemini --copilot
```

Browse what's available:

```bash
curl -fsSL .../install.sh | sh -s -- --list
```

In tools without namespacing, the commands are plain `/handoff` and `/handoff-resume`.

### Install matrix

| Tool | Path | Install command |
| --- | --- | --- |
| Claude Code | plugin cache | `/plugin install agent-kit@egor-xyz` |
| Cursor | `~/.cursor/commands/` | `curl … --cursor` |
| Codex | `~/.codex/prompts/` | `curl … --codex` |
| Gemini | `~/.gemini/commands/` | `curl … --gemini` |
| Copilot | `.github/prompts/` | `curl … --copilot` |

Override target paths with env vars: `AGENT_KIT_CURSOR_DIR`, `AGENT_KIT_CODEX_DIR`, `AGENT_KIT_GEMINI_DIR`, `AGENT_KIT_COPILOT_DIR`, `AGENT_KIT_CLAUDE_DIR`.

### Updating

Claude Code:
```
/plugin marketplace update egor-xyz
```
Then open the plugin manager (`/plugin`), select `agent-kit`, choose **Update now**. The marketplace omits `version` from the plugin entry, so every commit on `main` ships as a new version.

Other tools: re-run the install command with `--force`:
```bash
curl -fsSL .../install.sh | sh -s -- agent-kit --cursor --force
```

## Flagship workflow — Session Handoff

```
   work...
     │
     ▼
  /agent-kit:handoff         ─▶  writes .agents/handoff.md (target, state, files, changes, dead ends, next step)
     │
     ▼
   /clear                    ─▶  fresh context
     │
     ▼
   /agent-kit:handoff-resume ─▶  reads .agents/handoff.md, verifies git state, echoes next step, WAITS
     │
     ▼
   "go"                      ─▶  agent continues exactly where the previous session stopped
```

Canonical schema: [`docs/handoff-spec.md`](./docs/handoff-spec.md).

## Plugins

| Plugin | Description | Commands | Skills | Tools |
| --- | --- | --- | --- | --- |
| [`agent-kit`](./plugins/agent-kit) | Portable workflows — starting with session handoff. | `/agent-kit:handoff`, `/agent-kit:handoff-resume` | `auto-handoff` | all |

More workflows coming as additional commands inside the same plugin (or as separate plugins for granular install). [Contribute one](./docs/CONTRIBUTING.md).

## Bundles

| Bundle | Includes |
| --- | --- |
| [`session-management`](./bundles/session-management.json) | `agent-kit` |

Install a bundle:

```bash
curl -fsSL .../install.sh | sh -s -- --bundle session-management --all
```

## Why agent-kit

The space is crowded with bag-of-snippets repos. `agent-kit` is different:

- **Workflow-first.** Each plugin = a cohesive workflow (commands + skills + docs), not loose snippets.
- **Quality bar.** Every plugin documents Purpose, When to Use, When NOT to Use, Example, Install. Enforced by CI. See [`docs/quality-bar.md`](./docs/quality-bar.md).
- **Handoff-native.** Sessions are disposable. Every workflow that produces stateful work documents how it integrates with `/agent-kit:handoff`.
- **Portable by design.** Single source of truth (Claude Code plugin format); other tools generated at install.

## Add your own

1. Read [`docs/CONTRIBUTING.md`](./docs/CONTRIBUTING.md) and [`docs/quality-bar.md`](./docs/quality-bar.md).
2. Drop your plugin in `plugins/<name>/`.
3. Register it in `.claude-plugin/marketplace.json`.
4. Open a PR.

## Repo layout

```
agent-kit/
├── .claude-plugin/marketplace.json   # Claude Code marketplace catalog (name: egor-xyz)
├── plugins/<name>/                   # canonical plugin source
├── bundles/<theme>.json              # themed plugin groups
├── install.sh                        # universal installer
├── lib/transforms/<tool>.sh          # per-tool frontmatter transforms
├── docs/                             # specs and conventions
└── AGENTS.md                         # repo intro for agent tools
```

## License

[MIT](./LICENSE).
