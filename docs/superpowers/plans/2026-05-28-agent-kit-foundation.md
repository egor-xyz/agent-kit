# agent-kit Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Scaffold the `agent-kit` repo with marketplace, flagship `session-handoff` plugin, universal installer, docs, and CI validation. First commit ships a fully-functional plugin and infrastructure for future contributions.

**Architecture:** Single repo doubles as Claude Code marketplace (`.claude-plugin/marketplace.json` + `plugins/<name>/`) and source for a shell installer that transforms files for Cursor/Codex/Gemini/Copilot.

**Tech Stack:** Markdown, JSON, POSIX shell. No node, no python at install time.

---

## Task 1 — Marketplace + plugin manifests

**Files:**
- Create: `.claude-plugin/marketplace.json`
- Create: `plugins/session-handoff/.claude-plugin/plugin.json`

## Task 2 — Flagship commands and skill

**Files:**
- Create: `plugins/session-handoff/commands/handoff.md`
- Create: `plugins/session-handoff/commands/resume.md`
- Create: `plugins/session-handoff/skills/handoff-discipline/SKILL.md`
- Create: `plugins/session-handoff/README.md`

## Task 3 — Universal installer + transforms

**Files:**
- Create: `install.sh`
- Create: `lib/transforms/claude.sh`
- Create: `lib/transforms/cursor.sh`
- Create: `lib/transforms/codex.sh`
- Create: `lib/transforms/gemini.sh`
- Create: `lib/transforms/copilot.sh`

## Task 4 — Bundles

**Files:**
- Create: `bundles/session-management.json`

## Task 5 — Docs

**Files:**
- Create: `docs/CONTRIBUTING.md`
- Create: `docs/handoff-spec.md`
- Create: `docs/tool-mapping.md`
- Create: `docs/quality-bar.md`
- Create: `AGENTS.md`

## Task 6 — README + LICENSE

**Files:**
- Create: `README.md`
- Create: `LICENSE`

## Task 7 — CI validation

**Files:**
- Create: `.github/workflows/validate.yml`

## Task 8 — Commit + push

- Stage everything, single feat commit, push to `origin/main`.
