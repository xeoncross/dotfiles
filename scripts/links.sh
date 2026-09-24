#!/usr/bin/env bash
# Symlinks the config files under home/ into $HOME, so edits apply in place.
# A real file in the way is moved to <dest>.backup-<timestamp>, never deleted.
set -euo pipefail
H="$(cd "$(dirname "${BASH_SOURCE[0]}")/../home" && pwd -P)"

link() {
  local src="$1" dest="$2"
  [[ -L $dest && "$(readlink "$dest")" == "$src" ]] && return
  if [[ -e $dest && ! -L $dest ]]; then
    mv "$dest" "$dest.backup-$(date +%Y%m%d-%H%M%S)"
    echo "backed up $dest"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  echo "linked $dest"
}

link "$H/.zshrc"                  "$HOME/.zshrc"
link "$H/.config/starship.toml"   "$HOME/.config/starship.toml"
link "$H/.config/wezterm"         "$HOME/.config/wezterm"
link "$H/.config/nvim"            "$HOME/.config/nvim"
link "$H/.config/herdr"           "$HOME/.config/herdr"
link "$H/.config/hax"             "$HOME/.config/hax"
link "$H/.vscode/settings.json"   "$HOME/Library/Application Support/Code/User/settings.json"
link "$H/.claude/settings.json"   "$HOME/.claude/settings.json"

# Pi: only authored files, so credentials and runtime state stay local
link "$H/.pi/agent/themes"        "$HOME/.pi/agent/themes"
link "$H/.pi/agent/extensions"    "$HOME/.pi/agent/extensions"
link "$H/.pi/agent/models.json"   "$HOME/.pi/agent/models.json"
link "$H/.pi/agent/settings.json" "$HOME/.pi/agent/settings.json"

# One shared AGENTS.md for every agent
link "$H/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link "$H/AGENTS.md" "$HOME/.codex/AGENTS.md"
link "$H/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"
link "$H/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
link "$H/AGENTS.md" "$HOME/.config/agents/AGENTS.md"
