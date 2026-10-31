# Window picker for tmux `prefix w` (tmux.conf runs it in a small split via
# `zsh -ci fzf_windows`): fuzzy-find any window in any session and jump to it.
fzf_windows() {
  local target
  target=$(tmux list-windows -a -F '#{session_name}:#{window_index}  #{window_name}  #{pane_current_path}' |
    fzf --reverse --no-sort --prompt='window> ') || return
  tmux switch-client -t "${target%% *}"
}
