#!/usr/bin/env bash
#
# Homebrew
#
# This ensures Homebrew is installed and configures it with common defaults.
#
# Usage: ./init/prepare.sh

set -euo pipefail

# macOS-specific flags (only valid on Darwin): set native arch for compiled
# gems/binaries on Apple Silicon.
if [ "$(uname -s)" = "Darwin" ]; then
  case "$(uname -m)" in
    arm64) export ARCHFLAGS='-arch arm64' ;;
  esac
fi

# create necessary directories
mkdir -p "$HOME/.zsh/custom"
mkdir -p "$HOME/Code"
mkdir -p "$HOME/.nvm"

# Check for Homebrew
if ! command -v brew >/dev/null 2>&1
then
  echo "  Installing Homebrew for you."

  # Install Homebrew (universal command for macOS and Linux)
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

fi

# Disable analytics https://docs.brew.sh/Analytics
if command -v brew >/dev/null 2>&1
then
  brew analytics off
fi
exit 0
