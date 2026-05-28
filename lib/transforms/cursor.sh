#!/usr/bin/env sh
# Cursor transform — keep `description`, drop `argument-hint` and `allowed-tools`.
awk '
  BEGIN { in_fm = 0; fm_seen = 0 }
  /^---$/ {
    if (!fm_seen) { fm_seen = 1; in_fm = 1; print; next }
    else if (in_fm) { in_fm = 0; print; next }
  }
  in_fm {
    if ($0 ~ /^argument-hint:/) next
    if ($0 ~ /^allowed-tools:/) next
    print; next
  }
  { print }
'
