#!/usr/bin/env bash
#
# Fonts — install everything in misc/fonts into the user font directory.
# Fonts that are already installed are left alone.

set -e

FONTS_SRC="$HOME/.dotfiles/misc/fonts"

if [ "$(uname -s)" = "Darwin" ]; then
  FONTS_DST="$HOME/Library/Fonts"
else
  FONTS_DST="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
fi

mkdir -p "$FONTS_DST"
installed=0
while IFS= read -r font; do
  if [ ! -f "$FONTS_DST/$(basename "$font")" ]; then
    cp "$font" "$FONTS_DST/"
    installed=$((installed + 1))
  fi
done < <(find "$FONTS_SRC" -type f \( -name '*.ttf' -o -name '*.otf' \))
echo "Installed $installed new font(s) into $FONTS_DST"

# Linux apps only see new fonts once the fontconfig cache is rebuilt.
if [ "$installed" -gt 0 ] && command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$FONTS_DST"
fi
