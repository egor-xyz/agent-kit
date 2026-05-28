#!/usr/bin/env sh
# Copilot transform — rewrap frontmatter as Copilot prompt format.
# Drops Claude-specific keys, keeps `description`, adds `mode: agent`.
awk '
  BEGIN { in_fm = 0; fm_seen = 0; emitted_mode = 0 }
  /^---$/ {
    if (!fm_seen) { fm_seen = 1; in_fm = 1; print; next }
    else if (in_fm) {
      if (!emitted_mode) print "mode: agent"
      in_fm = 0; print; next
    }
  }
  in_fm {
    if ($0 ~ /^argument-hint:/) next
    if ($0 ~ /^allowed-tools:/) next
    if ($0 ~ /^mode:/) emitted_mode = 1
    print; next
  }
  { print }
'
