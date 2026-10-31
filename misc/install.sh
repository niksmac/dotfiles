#!/usr/bin/env bash
#
# Fonts — install everything in misc/fonts into the user font directory.
# Geist Mono (the terminal + editor font on both macOS and Linux) is
# downloaded into misc/fonts/Geist_Mono first if it isn't there yet.
# Fonts that are already installed are left alone.

set -e

FONTS_SRC="$HOME/.dotfiles/misc/fonts"
GEIST_VERSION="1.9.0"
GEIST_DIR="$FONTS_SRC/Geist_Mono"

if [ "$(uname -s)" = "Darwin" ]; then
  FONTS_DST="$HOME/Library/Fonts"
else
  FONTS_DST="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
fi

if ! ls "$GEIST_DIR"/GeistMono-*.ttf >/dev/null 2>&1; then
  echo "Downloading Geist Mono v$GEIST_VERSION into $GEIST_DIR"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  curl -fsSL -o "$tmp/geist.zip" \
    "https://github.com/vercel/geist-font/releases/download/v$GEIST_VERSION/geist-font-v$GEIST_VERSION.zip"
  unzip -q "$tmp/geist.zip" -d "$tmp"
  mkdir -p "$GEIST_DIR"
  cp "$tmp"/geist-font/GeistMono/ttf/*.ttf "$tmp"/geist-font/OFL.txt "$GEIST_DIR"/
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
