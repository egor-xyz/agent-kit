#!/usr/bin/env sh
# Codex transform — strip YAML frontmatter entirely; Codex prompts = plain .md.
awk '
  BEGIN { in_fm = 0; fm_done = 0 }
  /^---$/ {
    if (!fm_done && !in_fm) { in_fm = 1; next }
    if (in_fm) { in_fm = 0; fm_done = 1; next }
  }
  !in_fm && fm_done { print; next }
  !in_fm && !fm_done { print; next }
'
