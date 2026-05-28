# Quality bar

Every plugin in `agent-kit` clears this bar before merge. Quality > quantity. The crowded skill-collection space (40+ repos, thousands of snippets) is bag-of-snippets; we are workflow-first.

## Mandatory for every plugin

1. **`README.md`** with these H2 sections (exact spelling, CI checks):
   - `## Purpose` — what problem this solves, in one paragraph.
   - `## When to Use` — concrete triggers.
   - `## When NOT to Use` — equally concrete.
   - `## Example` — show a real invocation and what the agent does.
   - `## Install` — at minimum the Claude Code native command, ideally the full shell-installer matrix.

2. **`.claude-plugin/plugin.json`** with required fields:
   - `name`, `description`, `version` (semver), `license` (`MIT` unless you have a reason), `keywords`.

3. **Workflow cohesion.** If your plugin ships multiple artifacts (commands + skills + hooks), they must serve **one** workflow. If they don't, split into multiple plugins.

4. **Handoff integration.** If the plugin produces stateful work that may outlast a session, document explicitly how it interacts with `/handoff` and `/handoff-resume`. If it doesn't produce stateful work, say so.

5. **No secrets.** No API keys, tokens, credentials anywhere.

6. **No user-specific absolute paths.** No `/Users/<you>/...`, no `/home/<you>/...`. Use `~` or repo-relative.

7. **No AI attribution.** No "Generated with…", no co-author lines.

8. **Self-contained.** The plugin must not reference files outside its own directory (Claude Code copies plugins to a cache; cross-references break).

## Strongly preferred

- **A working example** in `README.md` showing input → output / before → after.
- **Tool support matrix** in `README.md` (Claude Code / Cursor / Codex / Gemini / Copilot).
- **Cite related work.** If you're inspired by an existing skill or pattern, link it.

## Don't merge

- Duplicate of an existing plugin. If you have an idea for an existing area, open an issue first to discuss merging instead.
- "Generic helper" with no clear use case.
- Plugin whose README is shorter than its commands.
- More than one workflow per plugin.

## CI checks

`.github/workflows/validate.yml` runs:

- JSON validity for `marketplace.json` and every `plugin.json`.
- Every `plugins/*/README.md` contains the four required H2 headers.
- No `/Users/`, `/home/<user>/` literal paths.
- No `Co-Authored-By` or `Generated with Claude` lines.
