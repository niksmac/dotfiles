#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

export ARCHFLAGS='-arch arm64'

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
brew analytics off
exit 0
