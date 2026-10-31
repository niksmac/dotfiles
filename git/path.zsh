# Make brew's completion functions visible to compinit.
#
# This MUST happen in the path phase (before compinit runs). Do NOT `source`
# brew's `_git` here: that file ends with a bare call to its own completion
# function, which then executes _files/_tags outside of any completion
# context. That is what produces, on every interactive shell start:
#
#   (eval):1: no matches found: *:globbed-files
#   _tags:comptags:36: can only be called from completion function
#
# Adding the directory to fpath and letting compinit autoload `_git` is what
# git's own completion file recommends, and it keeps startup fast because the
# ~4000-line git-completion.bash is only parsed when `git <TAB>` is used.
if command -v brew >/dev/null 2>&1; then
  brew_completions="$(brew --prefix)/share/zsh/site-functions"
  if [[ -d $brew_completions ]]; then
    fpath=($brew_completions $fpath)
  fi
  unset brew_completions
fi