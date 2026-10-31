#!/bin/bash
#
# Ghostty — symlink config into place.
# Ghostty reads ~/.config/ghostty/config.ghostty on both OSes. We link only that
# one file: Ghostty also loads a legacy `config` beside it and, on macOS, the
# Application Support copies, so linking the same file under several names
# loads it several times and `config-file = ?linux.conf` reports
# "cycle detected". Links an older version of this script made there are removed.
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

link_config() {
  local dest="$1"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$CONFIG_SRC" ]; then
    echo "Already linked: $dest"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.backup"
    echo "Backed up: $dest -> $dest.backup"
  fi
  ln -s "$CONFIG_SRC" "$dest"
  echo "Linked: $dest -> $CONFIG_SRC"
}

# Remove only our own old links; leave anything else for the owner.
unlink_old() {
  local dest="$1"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$CONFIG_SRC" ]; then
    rm "$dest"
    echo "Removed old link: $dest"
  fi
}

mkdir -p "$XDG_DIR"
link_config "$XDG_DIR/config.ghostty"
unlink_old "$XDG_DIR/config"
unlink_old "$MACOS_DIR/config"
unlink_old "$MACOS_DIR/config.ghostty"

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
