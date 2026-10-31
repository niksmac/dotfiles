#!/usr/bin/env bash
#
# Claude Code — link the global CLAUDE.md (rules for every project) into
# ~/.claude (or $CLAUDE_CONFIG_DIR). Skills are linked by skills/install.sh.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
src="$SCRIPT_DIR/CLAUDE.md"
dst="$CONFIG_DIR/CLAUDE.md"

mkdir -p "$CONFIG_DIR"

if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "Already linked: CLAUDE.md"
    exit 0
fi

# Keep a local CLAUDE.md that differs from the repo's instead of losing it.
if [ -e "$dst" ] && ! [ -L "$dst" ] && ! cmp -s "$dst" "$src"; then
    mv "$dst" "$dst.backup"
    echo "Moved existing $dst to $dst.backup"
fi

rm -f "$dst"
ln -s "$src" "$dst"
echo "Linked: CLAUDE.md"
