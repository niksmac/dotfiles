#!/bin/bash
#
# Ghostty — symlink config into place.
# Ghostty loads (later overrides earlier):
#   ~/.config/ghostty/config.ghostty (or legacy `config`)
#   ~/Library/Application Support/com.mitchellh.ghostty/config.ghostty (or `config`)
# We link all four names at both locations to the same source file.

set -e

GHOSTTY_SRC_DIR="$HOME/.dotfiles/ghostty"
CONFIG_SRC="$GHOSTTY_SRC_DIR/config"

XDG_DIR="$HOME/.config/ghostty"
MACOS_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"

mkdir -p "$XDG_DIR"
mkdir -p "$MACOS_DIR"

for dst in \
  "$XDG_DIR/config" \
  "$XDG_DIR/config.ghostty" \
  "$MACOS_DIR/config" \
  "$MACOS_DIR/config.ghostty"
do
  rm -f "$dst"
  ln -s "$CONFIG_SRC" "$dst"
  echo "Linked: $dst -> $CONFIG_SRC"
done

echo "Done! Validate with: ghostty +show-config"
