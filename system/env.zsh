# Zed's CLI is `zed` on macOS and from the official Linux installer, but
# `zeditor` in distro packages; alias it so `zed`, `z` and `code` work anyway.
if (( ! $+commands[zed] && $+commands[zeditor] )); then
  alias zed=zeditor
  export EDITOR='zeditor --wait'
else
  export EDITOR='zed --wait'
fi
export CLICOLOR=1
