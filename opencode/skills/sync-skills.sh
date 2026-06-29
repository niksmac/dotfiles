#!/bin/bash

set -euo pipefail

DOTFILES_SKILLS="$HOME/.dotfiles/opencode/skills"
HERMES_SKILLS="$HOME/.hermes/skills"

mkdir -p "$HERMES_SKILLS"

for skill_path in "$DOTFILES_SKILLS"/*/SKILL.md; do
  [ -e "$skill_path" ] || continue
  skill_name="$(basename "$(dirname "$skill_path")")"
  target_path="$HERMES_SKILLS/$skill_name/SKILL.md"

  mkdir -p "$(dirname "$target_path")"
  rm -f "$target_path"
  ln -s "$skill_path" "$target_path"
  echo "linked: $skill_name -> $target_path"
done

echo "Done."
