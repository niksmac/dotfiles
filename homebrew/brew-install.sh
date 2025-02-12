#!/bin/bash

# Disable analytics before doing anything else
brew analytics off

# Common packages for all platforms
COMMON_PACKAGES=(
  git
  tmux
  vim
  node
  tree
  yt-dlp # Modern replacement for youtube-dl
  ripgrep # Faster alternative to ag/the_silver_searcher
  fd # Better alternative to find
  bat # Better cat
  exa # Better ls
  zsh
)

# macOS specific packages
MACOS_PACKAGES=(
  coreutils
  grc
  git-flow-avh
  wrk
  imagemagick
  ffmpeg
)

# macOS cask apps
MACOS_CASKS=(
  iterm2
  firefox
  discord
  telegram
  keepingyouawake
)

if [ "$(uname)" = "Darwin" ]; then
  echo "Installing macOS packages..."
  brew install "${COMMON_PACKAGES[@]}" "${MACOS_PACKAGES[@]}"
  brew install --cask "${MACOS_CASKS[@]}"
elif [ "$(uname)" = "Linux" ]; then
  echo "Installing Linux packages..."
  brew install "${COMMON_PACKAGES[@]}"
fi

exit 0
