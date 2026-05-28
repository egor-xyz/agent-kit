# Contributing to agent-kit

Thanks for considering a contribution. This repo's bar is **quality over quantity** — see [`quality-bar.md`](./quality-bar.md). Read that first.

## Add a new plugin

### 1. Pick a workflow, not a snippet

`agent-kit` plugins solve workflows: things you do regularly that span multiple tool calls or multiple sessions. Examples that fit: code review pass, debugging discipline, dependency upgrade dance. Examples that don't fit on their own: "format JSON", "translate this string" — those are one-off prompts.

If your idea is a single command with no surrounding ritual, consider adding it to an existing plugin instead of creating a new one.

### 2. Scaffold

```
plugins/<your-plugin>/
├── .claude-plugin/plugin.json
├── commands/<name>.md          # one .md per slash command
├── skills/<skill-name>/SKILL.md  # one dir per skill (optional)
└── README.md
```

### 3. Author files

**`plugin.json`:**

```json
{
  "name": "your-plugin",
  "version": "0.1.0",
  "description": "One sentence — what workflow this owns.",
  "author": {"name": "Your Name"},
  "homepage": "https://github.com/egor-xyz/agent-kit",
  "license": "MIT",
  "keywords": ["..."]
}
```

**`commands/<name>.md`** — Claude Code format (canonical):

```markdown
---
description: One-line for the palette.
argument-hint: [optional positional args]
allowed-tools: Bash, Read, Write, Edit
---

# /your-command

<body — what the agent should do, step by step>
```

**`skills/<skill>/SKILL.md`:**

```markdown
---
name: skill-slug
description: Use when ... (the model reads this to decide whether to invoke).
---

<body — when to invoke, what to do, when NOT to use>
```

**`README.md`** — must contain these exact H2 headers:

- `## Purpose`
- `## When to Use`
- `## When NOT to Use`
- `## Example`
- `## Install`

### 4. Register in the marketplace

Add a `plugins[]` entry to `.claude-plugin/marketplace.json`:

```json
{
  "name": "your-plugin",
  "source": "./plugins/your-plugin",
  "description": "...",
  "version": "0.1.0",
  "category": "...",
  "tags": ["..."]
}
```

### 5. (Optional) Add to a bundle

If your plugin is part of a themed group, add its name to (or create) a `bundles/<theme>.json`.

### 6. Test locally

```bash
# Claude Code: add as local marketplace
/plugin marketplace add /path/to/agent-kit
/plugin install your-plugin@agent-kit

# Other tools: test the installer
./install.sh your-plugin --cursor --force
```

### 7. Open a PR

Title: `feat(plugins): add <your-plugin>`.

PR body: brief description, link to the quality-bar checklist, screenshots/GIFs welcome.

## Conventions

- **Naming:** kebab-case for plugin names, slash-commands, and skills.
- **Frontmatter:** canonical = Claude Code format. Other tools are transformed at install.
- **Markdown only.** No binary assets unless absolutely required.
- **No AI attribution.** No `Co-Authored-By: Claude`, no "Generated with…" lines anywhere.
- **No absolute user paths.** No `/Users/<you>/...`. Use `~` or repo-relative.

## Merging vs duplicating

If a plugin with similar purpose exists, open an issue first to discuss merging or coexistence. We will close duplicate plugins.
