#!/usr/bin/env bash
#
# Fonts — install everything in misc/fonts into the user font directory.
# Fonts that are already installed are left alone.
#
# Monaco (terminal + editor font) ships only with macOS and can't be
# committed, so misc/fonts/Monaco is a gitignored local copy: macOS fills
# it from the system font, Linux installs from it when Monaco is missing.

set -e

FONTS_SRC="$HOME/.dotfiles/misc/fonts"
MONACO_SYS="/System/Library/Fonts/Monaco.ttf"
MONACO_DIR="$FONTS_SRC/Monaco"

if [ "$(uname -s)" = "Darwin" ]; then
  FONTS_DST="$HOME/Library/Fonts"
else
  FONTS_DST="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
fi

if [ -f "$MONACO_SYS" ] && [ ! -f "$MONACO_DIR/Monaco.ttf" ]; then
  mkdir -p "$MONACO_DIR"
  cp "$MONACO_SYS" "$MONACO_DIR/"
  echo "Saved local copy: $MONACO_DIR/Monaco.ttf"
fi

# macOS already has Monaco as a system font; don't install a second copy.
skip_dir="/nonexistent"
[ -f "$MONACO_SYS" ] && skip_dir="$MONACO_DIR"

mkdir -p "$FONTS_DST"
installed=0
while IFS= read -r font; do
  if [ ! -f "$FONTS_DST/$(basename "$font")" ]; then
    cp "$font" "$FONTS_DST/"
    installed=$((installed + 1))
  fi
done < <(find "$FONTS_SRC" -path "$skip_dir" -prune -o \
  -type f \( -name '*.ttf' -o -name '*.otf' \) -print)
echo "Installed $installed new font(s) into $FONTS_DST"

# Linux apps only see new fonts once the fontconfig cache is rebuilt.
if [ "$installed" -gt 0 ] && command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$FONTS_DST"
fi

if [ ! -f "$MONACO_SYS" ] && [ ! -f "$FONTS_DST/Monaco.ttf" ]; then
  echo "Monaco not installed: copy it from a Mac, then re-run this script:"
  echo "  mkdir -p $MONACO_DIR"
  echo "  scp <mac>:.dotfiles/misc/fonts/Monaco/Monaco.ttf $MONACO_DIR/"
fi
