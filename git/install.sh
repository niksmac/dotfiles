#!/bin/sh

# Installing commit-msg hook
sudo -v

rm -rf ~/.git-templates/hooks/
mkdir -p ~/.git-templates/hooks/

git config --global core.hooksPath ~/.git-templates/hooks
git config --global core.excludesfile ~/.gitignore_global
git config --global init.defaultBranch master
git config --global core.ignorecase false

# Copy commit-msg hook
yes | cp -rf ~/.dotfiles/git/commit-msg ~/.git-templates/hooks/
chmod +x ~/.git-templates/hooks/commit-msg

# Copy imperative verbs file
yes | cp -rf ~/.dotfiles/git/imperative_verbs.txt ~/.git-templates/hooks/
