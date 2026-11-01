#!/bin/bash
#
# Link every skill in ~/.dotfiles/skills into each agent's personal skills
# directory: Claude Code, OpenCode and Hermes.
#
# Each skill directory is linked as a whole, so files added to a skill in the
# repo show up without re-running this script, and skills that reference their
# own files (e.g. landing-page-architect -> skills/lp-*/SKILL.md) resolve.
# Old per-file mirrors (real directories of links into this repo) are replaced
# with a directory link. Links left behind by skills removed from the repo are
# pruned. Anything that isn't a link into this repo is never touched.

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

# True if directory $1 holds nothing but subdirectories, .DS_Store files and
# links into $2, i.e. it's an old per-file mirror that is safe to replace.
is_mirror_of () {
  local dir=$1 src=$2 entry
  while IFS= read -r entry; do
    if [ -L "$entry" ]; then
      case "$(readlink "$entry")" in
        "$src"/*) ;;
        *) return 1 ;;
      esac
    elif [ "$(basename "$entry")" != ".DS_Store" ]; then
      return 1
    fi
  done < <(find "$dir" ! -type d)
}

for target_dir in "${TARGETS[@]}"; do
  mkdir -p "$target_dir"

  # Prune links into this repo whose source no longer exists. find doesn't
  # descend into linked skill directories, so this only sees our own links.
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
    dst="$target_dir/$skill_name"

    if [ -L "$dst" ]; then
      if [ "$(readlink "$dst")" = "$skill_dir" ]; then
        echo "ok: $dst"
        continue
      fi
      case "$(readlink "$dst")" in
        "$DOTFILES_SKILLS"/*) rm -f "$dst" ;;
        *) echo "skipped: $dst links outside this repo" >&2; continue ;;
      esac
    elif [ -d "$dst" ]; then
      if ! is_mirror_of "$dst" "$skill_dir"; then
        echo "skipped: $dst has files that aren't links into this repo" >&2
        continue
      fi
      rm -rf "$dst"
      echo "replaced per-file links: $dst"
    elif [ -e "$dst" ]; then
      echo "skipped: $dst exists and is not a directory or link" >&2
      continue
    fi

    ln -s "$skill_dir" "$dst"
    echo "linked: $dst -> $skill_dir"
  done
done

echo "Done."
