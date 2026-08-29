#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# macOS-specific flags (only valid on Darwin)
if [ "$(uname -s)" = "Darwin" ]; then
  export ARCHFLAGS='-arch arm64'
fi

# create necessary directories

mkdir -p $HOME/.zsh/custom
mkdir -p $HOME/Code
mkdir -p $HOME/.nvm

# Check for Homebrew
if test ! $(which brew)
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
