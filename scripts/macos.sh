#!/usr/bin/env bash
# macOS system settings via `defaults write`. Idempotent.
# Removing a line here does not revert that setting on machines already set up.
# DRY_RUN=1 prints the commands without running them.
set -euo pipefail

run() {
  echo "+ $*"
  [[ ${DRY_RUN:-0} == 1 ]] || "$@"
}

# Global
run defaults write -g AppleInterfaceStyle -string Dark
run defaults write -g KeyRepeat -int 2         # fast key repeat
run defaults write -g InitialKeyRepeat -int 15 # short delay before repeat
# run defaults write -g _HIHideMenuBar -bool true # auto-hide the top menu
run defaults write -g AppleShowAllExtensions -bool true

# Dock
run defaults write com.apple.dock autohide -bool true

# Finder
run defaults write com.apple.finder FXPreferredViewStyle -string Nlsv # list view by default
run defaults write com.apple.finder CreateDesktop -bool false         # clean desktop

# Trackpad: tap to click, for built-in and Bluetooth trackpads
run defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
run defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Apply without logging out (key repeat may still need a re-login),
# then restart the apps that cache their settings.
run /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
run killall Dock Finder
