#!/usr/bin/env bash
# One-time migration off the old Nix version of this repo
# (nix-darwin + home-manager + nix-homebrew + Determinate Nix).
# Afterwards, open a new terminal and run ./bootstrap.sh.
# DRY_RUN=1 prints what would happen without changing anything.
set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
NIX_DARWIN="github:nix-darwin/nix-darwin/nix-darwin-26.05"

run() {
  echo "+ $*"
  [[ $DRY_RUN == 1 ]] || "$@"
}

# rm, but only for paths that exist (or are dangling symlinks).
remove() {
  local p
  for p in "$@"; do
    if [[ -e $p || -L $p ]]; then
      run rm -rf "$p"
    fi
  done
}

if [[ $DRY_RUN != 1 ]]; then
  echo "This removes home-manager's links, nix-homebrew, nix-darwin, and Nix itself."
  echo "Formulae, casks, and taps in /opt/homebrew are kept."
  read -r -p "Continue? [y/N] " reply
  [[ $reply == [yY] ]] || exit 1
  sudo -v # cache credentials for the steps below
fi

echo "==> Step 1: remove home-manager's links from $HOME"
# Only symlinks pointing into the last home-manager generation are removed.
hm_gen="$HOME/.local/state/home-manager/gcroots/current-home"
if [[ -L $hm_gen ]]; then
  hm_files="$(readlink "$hm_gen")/home-files"
  while IFS= read -r f; do
    t="$HOME/${f#./}"
    if [[ -L $t && "$(readlink "$t")" == /nix/store/*-home-manager-files/* ]]; then
      remove "$t"
    fi
  done < <(cd "$hm_files" && find . -type l -o -type f)
fi
# Copied (not linked) fonts, and home-manager's own state
remove "$HOME/Library/Fonts/HomeManager" "$HOME/.local/state/home-manager"

echo "==> Step 2: replace nix-homebrew's brew with vanilla Homebrew"
if [[ -e /opt/homebrew/.managed_by_nix_darwin ]]; then
  # These point into /nix/store and would break once Nix is gone.
  for p in /opt/homebrew/bin/brew /opt/homebrew/Library/Homebrew \
    /opt/homebrew/Library/.homebrew-is-managed-by-nix /opt/homebrew/.managed_by_nix_darwin; do
    if [[ -e $p || -L $p ]]; then
      run sudo rm -rf "$p"
    fi
  done
  # The installer turns the existing /opt/homebrew into a git checkout and
  # keeps the installed kegs, casks, and taps.
  if [[ $DRY_RUN == 1 ]]; then
    echo "+ install Homebrew with the official installer"
  else
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
else
  echo "    /opt/homebrew is not managed by nix-homebrew, skipping"
fi

echo "==> Step 3: uninstall nix-darwin (restores the stock /etc files)"
if [[ -e /run/current-system/sw/bin/darwin-rebuild ]]; then
  # sudo resets PATH, so pass nix's absolute path.
  run sudo "$(command -v nix)" run "$NIX_DARWIN#darwin-uninstaller"
else
  echo "    nix-darwin not found, skipping"
fi

echo "==> Step 4: uninstall Determinate Nix (removes /nix)"
if [[ -x /nix/nix-installer ]]; then
  run /nix/nix-installer uninstall
else
  echo "    /nix/nix-installer not found, skipping"
fi
# Per-user Nix leftovers that pointed into /nix
remove "$HOME/.nix-profile" "$HOME/.nix-defexpr" "$HOME/.local/state/nix"

echo "==> Done. Open a new terminal, then run ./bootstrap.sh."
