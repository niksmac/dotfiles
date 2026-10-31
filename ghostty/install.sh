#!/bin/bash
#
# Ghostty — symlink config into place.
# Ghostty loads (later overrides earlier):
#   ~/.config/ghostty/config.ghostty (or legacy `config`)
#   ~/Library/Application Support/com.mitchellh.ghostty/config.ghostty (or `config`)  [macOS]
# We link both names at each location to the same source file.
#
# On Linux, linux-keybinds.conf is also linked as `linux.conf`, which the main
# config pulls in via `config-file = ?linux.conf`. It is linked both beside the
# config symlink and beside the source file (gitignored), so it loads however
# Ghostty resolves the relative path. macOS never gets a linux.conf.

set -e

GHOSTTY_SRC_DIR="$HOME/.dotfiles/ghostty"
CONFIG_SRC="$GHOSTTY_SRC_DIR/config"
LINUX_SRC="$GHOSTTY_SRC_DIR/linux-keybinds.conf"

XDG_DIR="$HOME/.config/ghostty"
MACOS_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"

config_dirs=("$XDG_DIR")
if [ "$(uname -s)" = "Darwin" ]; then
  config_dirs+=("$MACOS_DIR")
fi

for dir in "${config_dirs[@]}"; do
  mkdir -p "$dir"
  for name in config config.ghostty; do
    rm -f "$dir/$name"
    ln -s "$CONFIG_SRC" "$dir/$name"
    echo "Linked: $dir/$name -> $CONFIG_SRC"
  done
done

if [ "$(uname -s)" = "Linux" ]; then
  rm -f "$XDG_DIR/linux.conf"
  ln -s "$LINUX_SRC" "$XDG_DIR/linux.conf"
  echo "Linked: $XDG_DIR/linux.conf -> $LINUX_SRC"
  # Relative link: stays valid wherever the repo is checked out.
  rm -f "$GHOSTTY_SRC_DIR/linux.conf"
  ln -s linux-keybinds.conf "$GHOSTTY_SRC_DIR/linux.conf"
  echo "Linked: $GHOSTTY_SRC_DIR/linux.conf -> linux-keybinds.conf"
else
  rm -f "$GHOSTTY_SRC_DIR/linux.conf"
fi

echo "Done! Validate with: ghostty +show-config"
