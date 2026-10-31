# $ZSH/bin and ./bin should be on PATH everywhere; macOS /usr/local paths are Mac-only.
export PATH="$ZSH/bin:$PATH"

if [ "$IS_MAC" = true ]; then
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
  export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
fi

export PATH="./bin:$PATH"
