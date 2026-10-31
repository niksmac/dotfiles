#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/opencode"

COMMANDS_TARGET="$CONFIG_DIR/commands"
mkdir -p "$COMMANDS_TARGET"

find -L "$COMMANDS_TARGET" -type l -exec rm {} + 2>/dev/null || true

for cmd_path in "$SCRIPT_DIR/commands"/*.md; do
    [ -e "$cmd_path" ] || continue
    cmd_name="$(basename "$cmd_path")"
    target_path="$COMMANDS_TARGET/$cmd_name"
    rm -f "$target_path"
    ln -s "$cmd_path" "$target_path"
    echo "Linked command: $cmd_name"
done

rm -f "$CONFIG_DIR/opencode.json"
ln -s "$SCRIPT_DIR/opencode.json" "$CONFIG_DIR/opencode.json"
echo "Linked: opencode.json"

echo "Done!"
