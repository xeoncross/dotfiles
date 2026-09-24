#!/usr/bin/env bash
# Installs Homebrew if needed, then makes the machine match ../Brewfile exactly.
# Anything not in the Brewfile is removed (casks are zapped). See AGENTS.md.
# DRY_RUN=1 lists what would be removed and changes nothing.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
BREWFILE="$ROOT/Brewfile"
DRY_RUN="${DRY_RUN:-0}"

if ! command -v brew >/dev/null 2>&1; then
  if [ "$DRY_RUN" = "1" ]; then
    echo "==> DRY_RUN: brew not found, would install Homebrew. Nothing else to check."
    exit 0
  fi
  echo "==> Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Put brew on PATH for this script (fresh installs are not on PATH yet).
for prefix in /opt/homebrew /usr/local; do
  if [ -x "$prefix/bin/brew" ]; then
    eval "$("$prefix/bin/brew" shellenv)"
    break
  fi
done

if [ "$DRY_RUN" = "1" ]; then
  echo "==> DRY_RUN: missing from this machine"
  brew bundle check --file "$BREWFILE" --verbose || true
  echo "==> DRY_RUN: would be removed (casks zapped)"
  # Without --force this only lists, and exits 1 when something would be removed.
  brew bundle cleanup --file "$BREWFILE" || true
  exit 0
fi

echo "==> brew update"
brew update

echo "==> brew bundle install"
brew bundle install --file "$BREWFILE" --force

echo "==> brew bundle cleanup (zap anything not in the Brewfile)"
brew bundle cleanup --file "$BREWFILE" --force --zap
