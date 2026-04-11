#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"
TARGET_BASE="$HOME/.config/opencode/skills"

mkdir -p "$TARGET_BASE"

for skill_path in "$SKILLS_DIR"/*/SKILL.md; do
    [ -e "$skill_path" ] || continue
    skill_name="$(basename "$(dirname "$skill_path")")"
    target_path="$TARGET_BASE/$skill_name/SKILL.md"

    mkdir -p "$(dirname "$target_path")"

    rm -f "$target_path"
    ln -s "$skill_path" "$target_path"
    echo "Linked: $skill_name"
done

echo "Done!"
