#!/usr/bin/env bash
# macOS settings. Removing a line does not revert that setting.
set -euo pipefail

defaults write -g AppleInterfaceStyle -string Dark
defaults write -g KeyRepeat -int 2         # fast key repeat
defaults write -g InitialKeyRepeat -int 15 # short delay before repeat
# defaults write -g _HIHideMenuBar -bool true # auto-hide the top menu
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv # list view
defaults write com.apple.finder CreateDesktop -bool false         # clean desktop
# tap to click, built-in and Bluetooth trackpads
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Apply now (key repeat may still need a re-login) and restart apps that cache settings
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
killall Dock Finder
