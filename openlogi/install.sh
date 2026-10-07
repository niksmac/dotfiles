#!/bin/bash
#
# OpenLogi — link the config directory into place.
#
# The whole directory is linked, not config.toml itself: OpenLogi saves the
# config with an atomic temp-file + rename (atomic-write-file), and a rename
# REPLACES a file-level symlink — the repo copy would silently go stale on the
# first GUI save. A directory link keeps every atomic write pointed here.
# Locks, sockets and backups live here too, but are gitignored.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XDG_DIR="$HOME/.config/openlogi"

if [ -L "$XDG_DIR" ]; then
  if [ "$(readlink "$XDG_DIR")" = "$SCRIPT_DIR" ]; then
    echo "Already linked: $XDG_DIR -> $SCRIPT_DIR"
    exit 0
  fi
  rm "$XDG_DIR"
elif [ -d "$XDG_DIR" ]; then
  # Real directory still present (fresh machine or re-install): adopt its
  # contents into the repo, then replace it with the link.
  find "$XDG_DIR" -mindepth 1 -maxdepth 1 -exec mv {} "$SCRIPT_DIR" \;
  rmdir "$XDG_DIR"
fi

mkdir -p "$(dirname "$XDG_DIR")"
ln -s "$SCRIPT_DIR" "$XDG_DIR"
echo "Linked: $XDG_DIR -> $SCRIPT_DIR"
