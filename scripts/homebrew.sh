#!/usr/bin/env bash
# Installs Homebrew if needed, then makes the machine match Brewfile exactly:
# anything not listed is removed and casks are zapped (see AGENTS.md).
set -euo pipefail
BREWFILE="$(dirname "${BASH_SOURCE[0]}")/../Brewfile"

if ! command -v brew >/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x $brew ]] && eval "$("$brew" shellenv)" && break
  done
fi

brew bundle install --file "$BREWFILE" --force
brew bundle cleanup --file "$BREWFILE" --force --zap
