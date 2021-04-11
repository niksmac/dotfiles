#!/usr/bin/env bash
info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

info "Installing vscode plugins"

code --install-extension akamud.vscode-theme-onedark
code --install-extension amatiasq.sort-imports
code --install-extension bradlc.vscode-tailwindcss
code --install-extension dbaeumer.vscode-eslint
code --install-extension emroussel.atom-icons
code --install-extension esbenp.prettier-vscode
code --install-extension wix.vscode-import-cost
code --install-extension Wscats.omi-snippets

yes | rm "${HOME}/Library/Application Support/Code/User/settings.json"
ln -s "${HOME}/.dotfiles/vscode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
