#!/bin/sh

# Installing commit-msg hook
sudo -v

rm -rf ~/.git-templates/hooks/
mkdir -p ~/.git-templates/hooks/
git config --global core.hooksPath ~/.git-templates/hooks
yes | cp -rf ~/.dotfiles/git/commit-msg ~/.git-templates/hooks/
chmod +x ~/.git-templates/hooks/commit-msg
