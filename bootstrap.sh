#!/usr/bin/env bash
# Sets up this Mac from the repo. Idempotent: re-run it after any change.
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
