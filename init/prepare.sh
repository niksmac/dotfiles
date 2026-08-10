#!/usr/bin/env bash
#
# Homebrew
#
# This ensures Homebrew is installed and configures it with common defaults.
#
# Usage: ./init/prepare.sh

set -euo pipefail

# set native arch for compiled gems/binaries
case "$(uname -m)" in
  arm64) export ARCHFLAGS='-arch arm64' ;;
esac

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
brew analytics off
