#!/bin/bash

set -euo pipefail

DOTFILES_SKILLS="$HOME/.dotfiles/skills"
HERMES_SKILLS="$HOME/.hermes/skills"
OPENCODE_SKILLS="$HOME/.config/opencode/skills"

for target_dir in "$HERMES_SKILLS" "$OPENCODE_SKILLS"; do
  mkdir -p "$target_dir"

  for skill_path in "$DOTFILES_SKILLS"/*/SKILL.md; do
    [ -e "$skill_path" ] || continue
    skill_name="$(basename "$(dirname "$skill_path")")"
    target_path="$target_dir/$skill_name/SKILL.md"

    mkdir -p "$(dirname "$target_path")"
    rm -f "$target_path"
    ln -s "$skill_path" "$target_path"
    echo "linked: $skill_name -> $target_path"
  done
done

echo "Done."
