#!/usr/bin/env bash
#
# Toshy — macOS keyboard shortcuts on Linux: Cmd+C/V/T/W/… work in every app
# (in terminals they become ctrl+shift+…), and Ctrl stays Ctrl in terminals,
# so Ctrl+C still interrupts. https://github.com/RedBearAK/toshy
#
# Installs Toshy if it's missing, writes each toshy/slices/<name>.py into
# the matching SLICE_MARK section of ~/.config/toshy/toshy_config.py (the
# parts Toshy keeps across upgrades), and restarts Toshy when they change.
# Linux only.

[ "$(uname -s)" = "Linux" ] || exit 0

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config/toshy/toshy_config.py"
SRC_DIR="$HOME/.cache/toshy-src"
TOSHY_BIN="$HOME/.local/bin"

# Toshy has to be the only remapper. GNOME's "swap Ctrl/Super/Alt" options
# would make it misread the Cmd key, so drop them.
if command -v gsettings >/dev/null 2>&1 &&
   gsettings list-schemas 2>/dev/null | grep -qx org.gnome.desktop.input-sources; then
  opts="$(gsettings get org.gnome.desktop.input-sources xkb-options)"
  kept="$(python3 -c '
import ast, sys
opts = ast.literal_eval(sys.argv[1].removeprefix("@as ").strip())
keep = [o for o in opts if not o.startswith(("altwin:", "ctrl:swap_"))]
print(repr(keep) if keep != opts else "")' "$opts")"
  if [ -n "$kept" ]; then
    gsettings set org.gnome.desktop.input-sources xkb-options "$kept"
    echo "Removed modifier swaps from GNOME xkb-options (was $opts)"
  fi
fi
# keyd (an older setup here mapped Cmd to Ctrl) would remap under Toshy.
# Stop it; /etc/keyd is left alone, so `sudo systemctl enable --now keyd`
# brings it back.
if systemctl is-enabled --quiet keyd 2>/dev/null || systemctl is-active --quiet keyd 2>/dev/null; then
  echo "Disabling keyd so Toshy is the only remapper (asks for your password)"
  sudo systemctl disable --now keyd
fi

# Toshy sends terminals their default shortcuts (Cmd+C -> ctrl+shift+c, ...)
# and keeps Ctrl+<letter> for the shell. Custom Ptyxis shortcuts (the keyd
# setup bound copy/paste/new tab to Ctrl+C/V/T) break that, so reset them to
# Ptyxis's defaults, keeping a copy of the old ones.
PTYXIS_KEYS=/org/gnome/Ptyxis/Shortcuts/
if command -v dconf >/dev/null 2>&1 && [ -n "$(dconf list "$PTYXIS_KEYS" 2>/dev/null)" ]; then
  backup="$HOME/.config/ptyxis-shortcuts.backup.ini"
  dconf dump "$PTYXIS_KEYS" > "$backup"
  dconf reset -f "$PTYXIS_KEYS"
  echo "Reset custom Ptyxis shortcuts to defaults (old ones in $backup;"
  echo "  restore with: dconf load $PTYXIS_KEYS < $backup)"
fi

if [ ! -f "$CONFIG" ]; then
  echo "Installing Toshy (it asks a few questions and for your password)"
  if [ -d "$SRC_DIR/.git" ]; then
    git -C "$SRC_DIR" pull --ff-only
  else
    git clone --depth 1 https://github.com/RedBearAK/toshy.git "$SRC_DIR"
  fi
  (cd "$SRC_DIR" && ./setup_toshy.py install)
fi

# GNOME on Wayland: Toshy needs a shell extension to see the focused app.
# GNOME Shell asks for confirmation, then installs and enables it.
if [ "$XDG_SESSION_TYPE" = "wayland" ] && [[ "$XDG_CURRENT_DESKTOP" == *GNOME* ]] &&
   ! gnome-extensions list --enabled 2>/dev/null |
     grep -qE '^(focused-window-dbus@flexagoon.com|window-calls-extended@hseliger.eu|xremap@k0kubun.com)$'; then
  gdbus call --session --dest org.gnome.Shell.Extensions \
    --object-path /org/gnome/Shell/Extensions \
    --method org.gnome.Shell.Extensions.InstallRemoteExtension \
    focused-window-dbus@flexagoon.com >/dev/null ||
    echo "Install the 'Focused Window D-Bus' GNOME extension so Toshy works on Wayland"
fi

if [ ! -f "$CONFIG" ]; then
  echo "Toshy config not found at $CONFIG; skipping config slices"
  exit 0
fi

changed="$(python3 - "$CONFIG" "$SCRIPT_DIR"/slices/*.py <<'EOF'
import pathlib, re, sys

config = pathlib.Path(sys.argv[1])
text = before = config.read_text()
for path in map(pathlib.Path, sys.argv[2:]):
    name = re.escape(path.stem)
    marks = re.compile(rf'(###  SLICE_MARK_START: {name}  ###[^\n]*\n)'
                       rf'.*?(###  SLICE_MARK_END: {name}  ###)', re.S)
    if not marks.search(text):
        sys.exit(f"No '{path.stem}' slice in {config}")
    text = marks.sub(lambda m: m.group(1) + path.read_text() + m.group(2), text, count=1)
if text != before:
    config.write_text(text)
    print("yes")
EOF
)"

if [ -n "$changed" ]; then
  echo "Updated Toshy config slices"
  # Restart whichever is running: the systemd user service (normal after a
  # login) or the manually started copy (right after the first install).
  if systemctl --user is-active --quiet toshy-config 2>/dev/null; then
    systemctl --user restart toshy-config && echo "Restarted Toshy"
  elif [ -x "$TOSHY_BIN/toshy-config-restart" ]; then
    "$TOSHY_BIN/toshy-config-restart" >/dev/null 2>&1 || true
    echo "Restarted Toshy"
  fi
else
  echo "Toshy config slices already up to date"
fi
