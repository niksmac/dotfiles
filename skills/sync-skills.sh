#!/bin/bash
#
# Link every skill in ~/.dotfiles/skills into each agent's personal skills
# directory: Claude Code, OpenCode and Hermes.
#
# Each skill directory is mirrored file by file (real directories, symlinked
# files), so skills that reference their own files (e.g. landing-page-architect
# -> skills/lp-*/SKILL.md) resolve, and edits in the repo show up immediately.
# Links left behind by skills removed from the repo are pruned. Files that
# aren't symlinks into this repo are never touched.

set -euo pipefail

DOTFILES_SKILLS="$HOME/.dotfiles/skills"

TARGETS=(
  "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"
  "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills"
  "${HERMES_HOME:-$HOME/.hermes}/skills"
)

# Remove $1 and then each now-empty parent directory, stopping at $2.
remove_and_prune_parents () {
  local path=$1 root=$2 dir
  rm -f "$path"
  dir="$(dirname "$path")"
  while [ "$dir" != "$root" ] && rmdir "$dir" 2>/dev/null; do
    dir="$(dirname "$dir")"
  done
}

for target_dir in "${TARGETS[@]}"; do
  mkdir -p "$target_dir"

  # Prune links into this repo whose source no longer exists.
  while IFS= read -r link; do
    case "$(readlink "$link")" in
      "$DOTFILES_SKILLS"/*)
        if [ ! -e "$link" ]; then
          remove_and_prune_parents "$link" "$target_dir"
          echo "pruned: $link"
        fi
        ;;
    esac
  done < <(find "$target_dir" -type l)

  for skill_md in "$DOTFILES_SKILLS"/*/SKILL.md; do
    [ -e "$skill_md" ] || continue
    skill_dir="$(dirname "$skill_md")"
    skill_name="$(basename "$skill_dir")"

    while IFS= read -r src; do
      dst="$target_dir/$skill_name/${src#"$skill_dir"/}"
      if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "skipped: $dst exists and is not a link" >&2
        continue
      fi
      mkdir -p "$(dirname "$dst")"
      ln -sfn "$src" "$dst"
    done < <(find "$skill_dir" -type f ! -name '.DS_Store')

    echo "linked: $skill_name -> $target_dir/$skill_name"
  done
done

echo "Done."
