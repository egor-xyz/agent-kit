# Tool mapping

How `agent-kit`'s canonical Claude Code plugin format maps to other agent tools. Used by `install.sh` transforms in `lib/transforms/`.

## Canonical format (Claude Code)

Commands live in `plugins/<name>/commands/<cmd>.md` with YAML frontmatter:

```yaml
---
description: One-line for the command palette.
argument-hint: [optional positional args]
allowed-tools: Bash, Read, Write
---
```

Skills live in `plugins/<name>/skills/<skill>/SKILL.md` with frontmatter:

```yaml
---
name: skill-slug
description: Use when ... (model uses this to decide whether to invoke).
---
```

## Per-tool mapping

### Claude Code

- **Native plugin install** via `/plugin install <name>@agent-kit`. No transform needed.
- **Flat-file fallback:** `~/.claude/commands/<cmd>.md`. Passthrough.

### Cursor

- **Path:** `~/.cursor/commands/<cmd>.md` (global) or `.cursor/commands/<cmd>.md` (project).
- **Frontmatter:** keep `description`. Drop `argument-hint` and `allowed-tools` (Cursor ignores).
- **Skills:** Cursor has no first-class skill concept; document the behaviour as a command instead, or paste into `.cursorrules` / `AGENTS.md`.

### Codex CLI

- **Path:** `~/.codex/prompts/<cmd>.md`.
- **Frontmatter:** strip entirely. Codex prompts are plain Markdown.
- **Discovery:** Codex reads `AGENTS.md` in the project for instructions.

### Gemini CLI

- **Path:** `~/.gemini/commands/<cmd>.md` (global) or `.gemini/commands/<cmd>.md` (project).
- **Frontmatter:** keep `description`. Drop CC-specific keys.
- **Discovery:** Gemini reads `GEMINI.md` in the project.

### GitHub Copilot

- **Path:** `.github/prompts/<cmd>.prompt.md` (project only).
- **Frontmatter:** keep `description`, add `mode: agent`. Drop CC-specific keys.
- **Discovery:** Copilot reads `.github/copilot-instructions.md` for repo-level rules.

## Universal AGENTS.md

Most tools (Codex, Cursor, several others) read an `AGENTS.md` at the project root. `agent-kit` ships one that points agents at the marketplace + handoff workflow.

## Adding a new tool

To add support for a new tool:

1. Create `lib/transforms/<tool>.sh` — reads from stdin, writes transformed file to stdout.
2. Add a flag in `install.sh` (`--<tool>`), a `case` branch in `install_for_tool()`, and the target dir env var.
3. Update this document.
4. Add a column to the install matrix in `README.md` and per-plugin READMEs.
5. Open a PR.
