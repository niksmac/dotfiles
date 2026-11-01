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

# Linux: install Ghostty if it's missing. Ghostty ships no official Linux
# packages; on Ubuntu/Debian use the .deb builds from mkasberg/ghostty-ubuntu
# (the ones Ghostty's docs point to), checked against the release's sha256.
# On macOS, install Ghostty from ghostty.org; this script only links config.
install_ghostty_deb() {
  local id ver arch tmp url sum
  # shellcheck disable=SC1091
  id="$(. /etc/os-release && echo "$ID")"
  case "$id" in
    ubuntu) ver="$(. /etc/os-release && echo "$VERSION_ID")" ;;
    debian) ver="$(. /etc/os-release && echo "$VERSION_CODENAME")" ;;
    *) echo "Ghostty is not installed; see https://ghostty.org/docs/install/binary"; return 0 ;;
  esac
  arch="$(dpkg --print-architecture)"
  read -r url sum < <(curl -fsSL https://api.github.com/repos/mkasberg/ghostty-ubuntu/releases/latest |
    python3 -I -c '
import json, sys
suffix = "_%s_%s.deb" % (sys.argv[1], sys.argv[2])
for a in json.load(sys.stdin)["assets"]:
    if a["name"].endswith(suffix):
        print(a["browser_download_url"], (a.get("digest") or "").removeprefix("sha256:") or "-")
        break' "$arch" "$ver") || true
  if [ -z "$url" ]; then
    echo "No Ghostty .deb for $id $ver ($arch); see https://ghostty.org/docs/install/binary"
    return 0
  fi
  tmp="$(mktemp -d)"
  echo "Installing Ghostty from $url (asks for your password)"
  curl -fsSL -o "$tmp/ghostty.deb" "$url"
  if [ "$sum" != "-" ] && ! echo "$sum  $tmp/ghostty.deb" | sha256sum -c --quiet -; then
    echo "Ghostty download failed its checksum; not installing"
    rm -rf "$tmp"
    return 1
  fi
  sudo apt-get install -y "$tmp/ghostty.deb"
  rm -rf "$tmp"
}
if [ "$(uname -s)" = "Linux" ] && ! command -v ghostty >/dev/null 2>&1 &&
   command -v apt-get >/dev/null 2>&1; then
  install_ghostty_deb
fi

# Linux: make Ghostty the default terminal. GNOME (Ctrl+Alt+T, Files' "Open
# in Terminal", apps that need a terminal) asks xdg-terminal-exec, which
# reads ~/.config/[<desktop>-]xdg-terminals.list; Debian-style scripts use
# the x-terminal-emulator alternative.
GHOSTTY_ENTRY="com.mitchellh.ghostty.desktop:new-window"
if [ "$(uname -s)" = "Linux" ] && command -v ghostty >/dev/null 2>&1; then
  for list in "$HOME/.config/xdg-terminals.list" "$HOME"/.config/*-xdg-terminals.list; do
    [ -e "$list" ] || [ "$list" = "$HOME/.config/xdg-terminals.list" ] || continue
    if [ "$(grep -v -e '^#' -e '^$' "$list" 2>/dev/null | head -1)" != "$GHOSTTY_ENTRY" ]; then
      [ -e "$list" ] && cp "$list" "$list.backup"
      echo "$GHOSTTY_ENTRY" > "$list"
      echo "Default terminal: Ghostty in $list"
    fi
  done
  ghostty_bin="$(command -v ghostty)"
  if update-alternatives --list x-terminal-emulator 2>/dev/null | grep -qx "$ghostty_bin" &&
     [ "$(readlink -f /etc/alternatives/x-terminal-emulator)" != "$ghostty_bin" ]; then
    echo "Setting x-terminal-emulator to Ghostty (asks for your password)"
    sudo update-alternatives --set x-terminal-emulator "$ghostty_bin"
  fi
fi

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
