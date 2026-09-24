#!/usr/bin/env bash
# Re-applies everything: Brewfile, symlinks, npm/go packages, macOS settings.
# Each step is also runnable on its own, e.g. scripts/links.sh.
# DRY_RUN=1 previews every step without changing anything.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

if [ -e /opt/homebrew/.managed_by_nix_darwin ]; then
  echo "This Mac still runs the old Nix setup. Run ./uninstall_nix.sh first."
  exit 1
fi

"$DIR/scripts/homebrew.sh"
"$DIR/scripts/links.sh"
"$DIR/scripts/packages.sh"
"$DIR/scripts/macos.sh"
