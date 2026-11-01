if [ "$IS_MAC" = true ]; then
  export LSCOLORS="exfxcxdxbxegedabagacad"
else
  if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b)"
  fi
fi
export CLICOLOR=true

fpath=($ZSH/functions $fpath)

autoload -U $ZSH/functions/*(:t)

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

zle -N newtab

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[5D' backward-word
bindkey '^[[5C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
# ctrl+←/→ (what Toshy sends on Linux for Option+←/→)
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
# Home/End as sent in application mode and by tmux (Toshy's Cmd+←/→)
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
# Ctrl+Insert: Toshy's Cmd+C in Ptyxis/Ghostty. The terminal copies when it
# has a selection and passes the key on otherwise; ignore it then
# (redisplay only redraws the line).
bindkey '^[[2;5~' redisplay
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char
