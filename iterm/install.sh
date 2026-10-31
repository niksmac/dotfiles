#!/usr/bin/env bash
#
# iTerm2 — load (and save) preferences from this folder, so the profile,
# colours and key mappings in com.googlecode.iterm2.plist are the ones used.
# Restart iTerm2 afterwards. macOS only.

[ "$(uname -s)" = "Darwin" ] || exit 0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$SCRIPT_DIR"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
echo "iTerm2 loads preferences from $SCRIPT_DIR"
