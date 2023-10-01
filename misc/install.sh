#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
# osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v


cd ~/.dotfiles/misc/fonts

find . -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} ~/Library/Fonts/ \;

cd -
