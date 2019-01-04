#!/usr/bin/env bash
#
# Prettier

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

info "Installing prettier for you!"

brew install prettier

exit 0
