#!/usr/bin/env bash
# Takes a fresh Mac from nothing to a fully configured machine.
# Run this once. After it finishes, use ./rebuild.sh for every later change.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

if [ -e /opt/homebrew/.managed_by_nix_darwin ]; then
  echo "This Mac still runs the old Nix setup. Run ./uninstall_nix.sh first."
  exit 1
fi

echo "==> Step 1: Homebrew and everything in Brewfile"
# The official Homebrew installer also installs the Xcode Command Line Tools.
"$DIR/scripts/homebrew.sh"

echo "==> Step 2: symlink ~/.dotfiles and the config files"
"$DIR/scripts/links.sh"

echo "==> Step 3: npm and go packages"
"$DIR/scripts/packages.sh"

echo "==> Step 4: macOS settings"
"$DIR/scripts/macos.sh"

echo "==> Done. Open a new terminal, then use ./rebuild.sh for future changes."
