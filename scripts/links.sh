#!/usr/bin/env bash
# Symlink authored config from this repo into $HOME so edits apply in place.
# Idempotent. Real files in the way are moved to <dest>.backup-<timestamp>.
# DRY_RUN=1 prints what would happen without touching anything.
set -euo pipefail

# -P: physical path, so running via ~/.dotfiles/scripts cannot self-link ~/.dotfiles
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
DOTFILES="$HOME/.dotfiles"
STAMP="$(date +%Y%m%d-%H%M%S)"

run() {
  if [[ ${DRY_RUN:-0} == 1 ]]; then
    echo "  [dry-run] $*"
  else
    "$@"
  fi
}

# link <src> <dest>: point dest at src, backing up any real file/dir at dest.
link() {
  local src="$1" dest="$2"
  if [[ -L $dest && "$(readlink "$dest")" == "$src" ]]; then
    echo "ok      $dest"
    return
  fi
  if [[ -L $dest ]]; then
    echo "relink  $dest -> $src (was $(readlink "$dest"))"
  elif [[ -e $dest ]]; then
    echo "backup  $dest -> $dest.backup-$STAMP"
    run mv "$dest" "$dest.backup-$STAMP"
    echo "link    $dest -> $src"
  else
    echo "link    $dest -> $src"
    run mkdir -p "$(dirname "$dest")"
  fi
  run ln -sfn "$src" "$dest"
}

# ~/.dotfiles is the stable path every other link goes through.
# Skip when the repo itself was cloned to ~/.dotfiles.
if [[ -L $DOTFILES || ! -d $DOTFILES || "$(cd "$DOTFILES" && pwd -P)" != "$ROOT" ]]; then
  link "$ROOT" "$DOTFILES"
fi

H="$DOTFILES/home"

# Shell
link "$H/.zshrc"                  "$HOME/.zshrc"
link "$H/.config/starship.toml"   "$HOME/.config/starship.toml"

# Apps
link "$H/.config/wezterm"         "$HOME/.config/wezterm"
link "$H/.config/nvim"            "$HOME/.config/nvim"
link "$H/.config/herdr"           "$HOME/.config/herdr"
link "$H/.config/hax"             "$HOME/.config/hax"
link "$H/.vscode/settings.json"   "$HOME/Library/Application Support/Code/User/settings.json"

# Claude
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
