#!/usr/bin/env bash
#
# Set up a _coder/ task folder in a repo:
#   init.sh [repo-root]   (default: current directory)
#
# Creates _coder/ with README.md, index.mjs and the type folders, ignores
# _coder/logs/, appends the task-folder section to AGENTS.md unless its
# heading is already there, and builds
# INDEX.md. Never overwrites existing files; safe to rerun.

set -euo pipefail

skill="$(cd "$(dirname "$0")/.." && pwd)"
repo="$(cd "${1:-.}" && pwd)"
coder="$repo/_coder"

mkdir -p "$coder"
for f in README.md index.mjs; do
  if [ -e "$coder/$f" ]; then
    echo "kept: _coder/$f"
  else
    command cp "$skill/assets/$f" "$coder/$f"
    echo "added: _coder/$f"
  fi
done

for d in issues plans docs reports specs benchmarks; do
  mkdir -p "$coder/$d"
  [ -n "$(ls -A "$coder/$d")" ] || touch "$coder/$d/.gitkeep"
done

ignore="$repo/.gitignore"
if ! grep -qsxF '_coder/logs/' "$ignore"; then
  [ -s "$ignore" ] && [ -n "$(tail -c1 "$ignore")" ] && echo >> "$ignore"
  echo '_coder/logs/' >> "$ignore"
  echo "added: _coder/logs/ to .gitignore"
fi

agents="$repo/AGENTS.md"
heading='## Task folder (`_coder/`)'
if grep -qsF "$heading" "$agents"; then
  echo "kept: AGENTS.md already has the _coder section"
else
  grep -qsF '_coder/' "$agents" && older=1 || older=0
  [ -e "$agents" ] || printf '# AGENTS.md\n' > "$agents"
  cat "$skill/assets/agents-snippet.md" >> "$agents"
  echo "added: _coder section to AGENTS.md"
  [ "$older" = 0 ] || echo "note: AGENTS.md mentioned _coder/ before; remove older _coder rules that conflict"
fi
if [ ! -e "$repo/CLAUDE.md" ]; then
  echo "note: no CLAUDE.md to load AGENTS.md"
elif ! grep -qsF 'AGENTS.md' "$repo/CLAUDE.md"; then
  echo "note: CLAUDE.md does not reference AGENTS.md"
fi

node "$coder/index.mjs"
