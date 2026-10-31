#!/usr/bin/env bash
#
# mpv — link mpv.conf wherever mpv looks for it on this OS.

set -e

MPV_SRC="$HOME/.dotfiles/mpv/mpv.conf"

config_dirs=("$HOME/.config/mpv")
if [ "$(uname -s)" = "Darwin" ]; then
  config_dirs+=("$HOME/Library/Application Support/mpv")
fi

for dir in "${config_dirs[@]}"; do
  mkdir -p "$dir"
  ln -sf "$MPV_SRC" "$dir/mpv.conf"
  echo "Linked: $dir/mpv.conf -> $MPV_SRC"
done
