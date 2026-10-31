#!/usr/bin/env bash
#
# Linux-only setup (script/install runs this on Linux hosts only).

# zshrc exports LANG/LC_ALL=en_US.UTF-8, which macOS always has. Linux only
# has it once generated; otherwise every shell warns "cannot change locale".
if ! locale -a 2>/dev/null | grep -qiE '^en_US\.utf-?8$'; then
  if command -v locale-gen >/dev/null 2>&1; then
    sudo locale-gen en_US.UTF-8
  else
    echo "en_US.UTF-8 locale is missing; install it with your distro's tools (e.g. glibc-langpack-en)"
  fi
fi

exit 0
