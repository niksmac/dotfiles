# Uses git's autocompletion for inner commands. Homebrew sticks it at
# $(brew --prefix)/share/zsh/site-functions/_git; on systems without brew
# (plain Linux distros) we just skip it.
if command -v brew >/dev/null 2>&1; then
  completion="$(brew --prefix)/share/zsh/site-functions/_git"
  if test -f "$completion"
  then
    source "$completion"
  fi
fi