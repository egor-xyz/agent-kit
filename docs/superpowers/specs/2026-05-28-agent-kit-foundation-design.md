# agent-kit Foundation — Design Spec

_Generated: 2026-05-28_

## Goal

Stand up `agent-kit` — a public repo of portable, install-once workflows for coding agents (Claude Code, Cursor, Codex, Gemini, Copilot). Ship the flagship `session-handoff` plugin and all infrastructure to add future plugins quickly.

## Thesis / Differentiation

The space (40+ skill-collection repos, 1000+ plugins indexed) is crowded with bag-of-snippets. `agent-kit` differentiates with:

1. **Workflow-first.** Each plugin = cohesive workflow bundle (commands + skills + hooks + docs), not loose snippets.
2. **Quality bar.** Every entry has explicit purpose, when-to-use, when-NOT-to-use, and example. Enforced by `docs/quality-bar.md` and CI.
3. **Handoff-native.** Repo's core thesis: agent sessions are disposable, work-in-progress is not. Every plugin documents how it integrates with the flagship handoff workflow.
4. **Portable by design.** Single source of truth (Claude Code plugin layout), universal installer translates to other tools.

## Architecture

Repo is dual-purpose:

1. **Claude Code marketplace.** `.claude-plugin/marketplace.json` at root. Users run `/plugin marketplace add egor-xyz/agent-kit` then `/plugin install <plugin>@agent-kit`. Native UX, no clone.
2. **Universal installer.** `install.sh` (curl-pipe-sh) reads canonical `plugins/<name>/` and copies/transforms files into target tool's location (Cursor `.cursor/commands/`, Codex `~/.codex/prompts/`, Gemini `~/.gemini/commands/`, Copilot `.github/prompts/`).

Canonical source = Claude Code plugin format under `plugins/<name>/`. Other tool variants generated on the fly via `lib/transforms/<tool>.sh`.

## Repo Layout

```
agent-kit/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   └── session-handoff/
│       ├── .claude-plugin/plugin.json
│       ├── commands/{handoff.md,resume.md}
│       ├── skills/handoff-discipline/SKILL.md
│       └── README.md
├── bundles/
│   └── session-management.json
├── install.sh
├── lib/transforms/{claude,cursor,codex,gemini,copilot}.sh
├── docs/
│   ├── CONTRIBUTING.md
│   ├── quality-bar.md
│   ├── handoff-spec.md
│   └── tool-mapping.md
├── AGENTS.md
├── README.md
├── LICENSE
└── .github/workflows/validate.yml
```

## Flagship: `session-handoff` plugin

Two commands, one skill, one spec doc.

- **`/handoff`** — dump current session state to `handoff.md`. Auto-populates Current State via `git status`, `git log -1`, `git diff --stat`. Writes all required H2 sections per `docs/handoff-spec.md`.
- **`/resume`** — read `handoff.md`, verify git state matches, echo Target + Next Step verbatim, **wait for user "go"** before any tool call.
- **`handoff-discipline` skill** — auto-trigger during long tasks; reminds agent to update `handoff.md` mid-flight.

Workflow: `work → /handoff → /clear → /resume → confirm → continue`.

### handoff.md schema (canonical)

Required H2 sections:
- **Target** — one sentence.
- **Current State** — branch, last commit, dirty/clean, tests passing.
- **Files Under Work** — table: path | status | one-line purpose.
- **Changes Made** — bullets per file, function/line refs.
- **Attempts & Dead Ends** — what tried, why failed (quote errors verbatim).
- **Open Questions / Assumptions** — flag unresolved.
- **Next Step** — exact command or file:line to resume at.
- **Context Pointers** — PRs, tickets, threads, prior handoffs.

Header: `_Generated: <ISO-8601 UTC>_`.

## Universal installer

**Invocation:**
```
curl -fsSL https://raw.githubusercontent.com/egor-xyz/agent-kit/main/install.sh | sh -s -- <plugin> [--cursor] [--codex] [--gemini] [--copilot] [--claude] [--all]
curl ... | sh -s -- --bundle <bundle-name> [flags]
curl ... | sh -s -- --list
```

**Behavior:** clone (or sparse-fetch) repo to tmp, resolve plugin or bundle, iterate target tools, pipe each `.md` through `lib/transforms/<tool>.sh`, write to tool's target dir. Refuse overwrite without `--force`. Honors env overrides (`AGENT_KIT_CURSOR_DIR=...`).

**Transforms:**

| Tool | Frontmatter | Target dir | Notes |
|---|---|---|---|
| Claude Code | passthrough | `~/.claude/commands/` | Prefer native `/plugin install` |
| Cursor | keep `description`, drop `argument-hint`/`allowed-tools` | `~/.cursor/commands/` | |
| Codex | strip frontmatter | `~/.codex/prompts/` | Plain `.md` |
| Gemini | keep `description` | `~/.gemini/commands/` | |
| Copilot | rewrap as `<name>.prompt.md` | `.github/prompts/` | Project only |

## README

Above-fold: H1 + tagline + tool-badge row + 30-sec demo placeholder.

Sections: pitch (3 lines) → demo → install (tabbed per tool) → flagship workflow diagram → plugin index table → why agent-kit (vs N) → add your own (link to CONTRIBUTING) → license.

## Quality bar

Every plugin must include:
- `README.md` with: Purpose, When to Use, When NOT to Use, Example invocation, Install matrix.
- `.claude-plugin/plugin.json` with `name`, `description`, `version`, `license`, `keywords`.
- If artifact produces stateful work: explicit note on how it integrates with `/handoff`.
- No secrets, no user-specific absolute paths.
- No AI attribution.

CI (`validate.yml`) checks:
- `marketplace.json` valid JSON, schema-conforming.
- Each `plugins/*/plugin.json` valid.
- Each plugin has `README.md` with required H2 sections (Purpose, When to Use, When NOT to Use).
- No `/Users/`, `/home/<user>/` literals.

## Distribution

- Self-register on `claudemarketplaces.com` after first push.
- Submit to `awesome-claude-plugins` curated lists.
- Tag releases (semver) for marketplace version pinning.

## Out of scope (this iteration)

- Npm-based CLI (shell installer is enough).
- Plugins beyond `session-handoff` (foundation only; community adds via PR).
- Hook artifacts (deferred until second plugin needs one).
- LSP/MCP server bundling (deferred).
