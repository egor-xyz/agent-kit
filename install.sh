#!/usr/bin/env sh
# agent-kit universal installer
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/egor-xyz/agent-kit/main/install.sh | sh -s -- <plugin> [flags]
#   curl ... | sh -s -- --bundle <bundle-name> [flags]
#   curl ... | sh -s -- --list
#
# Flags: --claude --cursor --codex --gemini --copilot --all --force
# Env overrides: AGENT_KIT_CLAUDE_DIR, AGENT_KIT_CURSOR_DIR, AGENT_KIT_CODEX_DIR,
#                AGENT_KIT_GEMINI_DIR, AGENT_KIT_COPILOT_DIR, AGENT_KIT_REF (default: main)

set -eu

REPO="${AGENT_KIT_REPO:-egor-xyz/agent-kit}"
REF="${AGENT_KIT_REF:-main}"
TARBALL_URL="https://codeload.github.com/${REPO}/tar.gz/${REF}"

CLAUDE_DIR="${AGENT_KIT_CLAUDE_DIR:-$HOME/.claude/commands}"
CURSOR_DIR="${AGENT_KIT_CURSOR_DIR:-$HOME/.cursor/commands}"
CODEX_DIR="${AGENT_KIT_CODEX_DIR:-$HOME/.codex/prompts}"
GEMINI_DIR="${AGENT_KIT_GEMINI_DIR:-$HOME/.gemini/commands}"
COPILOT_DIR="${AGENT_KIT_COPILOT_DIR:-./.github/prompts}"

FORCE=0
LIST_ONLY=0
BUNDLE=""
PLUGIN=""
TOOLS=""

die() { printf "error: %s\n" "$*" >&2; exit 1; }
info() { printf "%s\n" "$*"; }

# ---- parse args ----
while [ $# -gt 0 ]; do
  case "$1" in
    --list) LIST_ONLY=1 ;;
    --bundle) shift; BUNDLE="${1:-}" ;;
    --claude) TOOLS="$TOOLS claude" ;;
    --cursor) TOOLS="$TOOLS cursor" ;;
    --codex)  TOOLS="$TOOLS codex" ;;
    --gemini) TOOLS="$TOOLS gemini" ;;
    --copilot) TOOLS="$TOOLS copilot" ;;
    --all)    TOOLS="claude cursor codex gemini copilot" ;;
    --force)  FORCE=1 ;;
    -h|--help)
      sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    --*) die "unknown flag: $1" ;;
    *) PLUGIN="$1" ;;
  esac
  shift
done

# ---- fetch repo ----
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

info "→ fetching ${REPO}@${REF}…"
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$TARBALL_URL" | tar -xz -C "$TMP"
elif command -v wget >/dev/null 2>&1; then
  wget -qO- "$TARBALL_URL" | tar -xz -C "$TMP"
else
  die "need curl or wget"
fi

ROOT="$TMP/$(ls "$TMP")"
[ -d "$ROOT/plugins" ] || die "missing plugins/ in fetched repo"

# ---- --list ----
if [ "$LIST_ONLY" = "1" ]; then
  info ""
  info "Available plugins:"
  for d in "$ROOT"/plugins/*/; do
    name="$(basename "$d")"
    desc="$(grep -m1 '^> ' "$d/README.md" 2>/dev/null | sed 's/^> //' || echo "")"
    printf "  %-24s %s\n" "$name" "$desc"
  done
  info ""
  info "Available bundles:"
  if [ -d "$ROOT/bundles" ]; then
    for b in "$ROOT"/bundles/*.json; do
      [ -f "$b" ] || continue
      bname="$(basename "$b" .json)"
      printf "  %s\n" "$bname"
    done
  fi
  exit 0
fi

# ---- resolve plugins ----
PLUGINS=""
if [ -n "$BUNDLE" ]; then
  BFILE="$ROOT/bundles/$BUNDLE.json"
  [ -f "$BFILE" ] || die "bundle not found: $BUNDLE"
  PLUGINS="$(sed -n 's/.*"\([a-z0-9][a-z0-9-]*\)".*/\1/p' "$BFILE" | grep -v "^$BUNDLE$" || true)"
  [ -n "$PLUGINS" ] || die "bundle $BUNDLE has no plugins"
elif [ -n "$PLUGIN" ]; then
  PLUGINS="$PLUGIN"
else
  die "no plugin or bundle specified (try --list)"
fi

# ---- resolve tools ----
TOOLS="$(printf "%s\n" $TOOLS | awk '!seen[$0]++' | tr '\n' ' ')"
[ -n "$TOOLS" ] || die "no target tool specified (use --claude --cursor --codex --gemini --copilot or --all)"

# ---- install ----
install_for_tool() {
  plugin="$1"
  tool="$2"
  src_dir="$ROOT/plugins/$plugin"
  [ -d "$src_dir" ] || { info "  ✗ plugin not found: $plugin"; return 1; }

  case "$tool" in
    claude)  dest="$CLAUDE_DIR" ;;
    cursor)  dest="$CURSOR_DIR" ;;
    codex)   dest="$CODEX_DIR" ;;
    gemini)  dest="$GEMINI_DIR" ;;
    copilot) dest="$COPILOT_DIR" ;;
    *) info "  ✗ unknown tool: $tool"; return 1 ;;
  esac

  transform="$ROOT/lib/transforms/$tool.sh"
  [ -f "$transform" ] || { info "  ✗ no transform for $tool"; return 1; }

  mkdir -p "$dest"

  # commands
  if [ -d "$src_dir/commands" ]; then
    for cmd in "$src_dir"/commands/*.md; do
      [ -f "$cmd" ] || continue
      base="$(basename "$cmd")"
      case "$tool" in
        copilot) out="$dest/${base%.md}.prompt.md" ;;
        *)       out="$dest/$base" ;;
      esac
      if [ -e "$out" ] && [ "$FORCE" != "1" ]; then
        info "  ⊘ exists, skipping (use --force): $out"
        continue
      fi
      sh "$transform" <"$cmd" >"$out"
      info "  ✓ $tool ← $plugin/commands/$base → $out"
    done
  fi
}

info ""
for plugin in $PLUGINS; do
  info "Installing $plugin…"
  for tool in $TOOLS; do
    install_for_tool "$plugin" "$tool" || true
  done
done

info ""
info "Done. Restart your tool to pick up new commands."
