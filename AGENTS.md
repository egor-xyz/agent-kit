# agent-kit — instructions for agents

This file is read by Codex CLI, Cursor, and other agent tools that look for an `AGENTS.md` at the repository root. It is the agent-readable companion to [`README.md`](./README.md).

## What this repo is

`agent-kit` is a public collection of **portable workflows** for coding agents — skills, commands, hooks, and configs that work across Claude Code, Cursor, Codex, Gemini, and Copilot.

## Flagship workflow

**Session handoff.** Agent sessions are disposable; work-in-progress is not. The plugin `agent-kit` ships two commands:

- `/handoff` — dump current session state to `.agents/handoff.md` (target, files under work, changes made, dead ends, next step).
- `/handoff-resume` — read `.agents/handoff.md`, verify git state, print Target + Next Step, **wait for user confirmation**.

Workflow: `work → /handoff → /clear → /handoff-resume → confirm → continue`.

If you (the agent) are working on a long task that may outlast this session, write `.agents/handoff.md` proactively. See [`docs/handoff-spec.md`](./docs/handoff-spec.md) for the canonical schema.

## Repo layout (quick reference)

- `plugins/<name>/` — canonical plugin source (Claude Code format).
- `install.sh` — universal installer for Cursor/Codex/Gemini/Copilot.
- `lib/transforms/<tool>.sh` — per-tool frontmatter transforms.
- `docs/quality-bar.md` — the bar for new plugins.
- `docs/handoff-spec.md` — schema for `.agents/handoff.md`.
- `docs/tool-mapping.md` — how the canonical format maps to other tools.
- `docs/CONTRIBUTING.md` — how to add a plugin.

## If you're adding a plugin

Read [`docs/CONTRIBUTING.md`](./docs/CONTRIBUTING.md) and [`docs/quality-bar.md`](./docs/quality-bar.md) first.

## Rules

- No secrets in any file.
- No user-specific absolute paths.
- No AI attribution in commits, PRs, or content.
- Quality > quantity. One cohesive workflow per plugin.
