#!/usr/bin/env bash
info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

info "Installing vscode plugins"

## Run the below line to get installed plugins list
# code --list-extensions | xargs -L 1 echo code --install-extension

code --install-extension amatiasq.sort-imports
code --install-extension astro-build.astro-vscode
code --install-extension bradlc.vscode-tailwindcss
code --install-extension bungcip.better-toml
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension dbaeumer.vscode-eslint
code --install-extension emroussel.atom-icons
code --install-extension emroussel.atomize-atom-one-dark-theme
code --install-extension esbenp.prettier-vscode
code --install-extension JuanBlanco.solidity
code --install-extension rust-lang.rust-analyzer
code --install-extension vincaslt.highlight-matching-tag
code --install-extension willstakayama.vscode-nextjs-snippets
code --install-extension wix.vscode-import-cost
code --install-extension Wscats.omi-snippets

yes | rm "${HOME}/Library/Application Support/Code/User/settings.json"
ln -s "${HOME}/.dotfiles/vscode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
