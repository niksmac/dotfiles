#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"
CONFIG_DIR="$HOME/.config/opencode"

SKILLS_TARGET="$CONFIG_DIR/skills"
mkdir -p "$SKILLS_TARGET"

for skill_path in "$SKILLS_DIR"/*/SKILL.md; do
    [ -e "$skill_path" ] || continue
    skill_name="$(basename "$(dirname "$skill_path")")"
    target_path="$SKILLS_TARGET/$skill_name/SKILL.md"

    mkdir -p "$(dirname "$target_path")"
    rm -f "$target_path"
    ln -s "$skill_path" "$target_path"
    echo "Linked: $skill_name"
done

COMMANDS_TARGET="$CONFIG_DIR/commands"
mkdir -p "$COMMANDS_TARGET"
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
