#!/usr/bin/env zsh

if command -v pbcopy >/dev/null 2>&1; then
  alias pubkey="cat ~/.ssh/id_rsa.pub | pbcopy && echo '=> Public key copied to pasteboard.'"
elif command -v xclip >/dev/null 2>&1; then
  alias pubkey="cat ~/.ssh/id_rsa.pub | xclip -selection clipboard && echo '=> Public key copied to clipboard.'"
elif command -v xsel >/dev/null 2>&1; then
  alias pubkey="cat ~/.ssh/id_rsa.pub | xsel --clipboard && echo '=> Public key copied to clipboard.'"
else
  alias pubkey="cat ~/.ssh/id_rsa.pub && echo '=> No clipboard tool found. Install xclip or pbcopy.'"
fi
