#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

link_dir() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$src" ]; then
    echo "skip: source not found: $src"
    return 0
  fi

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "${dest}.bak-${TS}"
    echo "backup: $dest -> ${dest}.bak-${TS}"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  echo "link: $dest -> $src"
}

# Claude Code (global)
link_dir "$ROOT_DIR/.config/claude/agents"   "$HOME/.claude/agents"
link_dir "$ROOT_DIR/.config/claude/commands" "$HOME/.claude/commands"
link_dir "$ROOT_DIR/.config/claude/skills"   "$HOME/.claude/skills"
link_dir "$ROOT_DIR/.config/claude/settings.json" "$HOME/.claude/settings.json"

# Cursor (global commands)
link_dir "$ROOT_DIR/.config/cursor/commands" "$HOME/.cursor/commands"
# Cursor (global rules)
link_dir "$ROOT_DIR/.config/cursor/rules" "$HOME/.cursor/rules"

# Gemini CLI (global commands)
link_dir "$ROOT_DIR/.config/gemini/commands" "$HOME/.gemini/commands"

# Codex CLI (global skills)
link_dir "$ROOT_DIR/.config/codex/skills" "$HOME/.codex/skills/custom"

echo "done"
