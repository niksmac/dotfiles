#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
  fi

fi

# Install the correct homebrew for each OS type
if test "$(uname)" = "Darwin"
then
  # Install homebrew packages
  brew install -s zsh zsh-completions grc coreutils tmux youtube-dl vim node wget git tree tor git-flow wrk zplug yarn imagemagick ffmpeg prettier
  # Tap cask
  # brew tap homebrew/cask
  # Install cask items
  brew install --cask flux transmission vlc iterm2 firefox visual-studio-code imageoptim
elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
then
  # Install homebrew packages
  brew install grc tmux youtube-dl vim node tree tor pre-commit imagemagick zplug
fi

# Disable analytics https://docs.brew.sh/Analytics
brew analytics off
exit 0
