autoload colors && colors

branch() {
  git symbolic-ref --short HEAD 2>/dev/null
}

git_dirty() {
  local b count
  b=$(branch) || return
  count=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [[ $count -gt 0 ]]; then
    echo "on %{$fg_bold[red]%}$b%{$reset_color%} %{$fg_bold[magenta]%}+$count%{$reset_color%}"
  else
    echo "on %{$fg_bold[green]%}$b%{$reset_color%}"
  fi
}

need_push() {
  if [[ -n $(git cherry -v @{upstream} 2>/dev/null) ]]; then
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  else
    echo " "
  fi
}

node_version() {
  local files=(package.json yarn.lock package-lock.json pnpm-lock.json tsconfig.json)
  for f in $files; do
    [[ -f $f ]] && break
  done && {
    local v
    v=$(fnm current 2>/dev/null || node --version 2>/dev/null) && echo " %{$fg_bold[green]%}node@${v#v}%{$reset_color%}"
  }
}

python_version() {
  local files=(requirements.txt setup.py setup.cfg pyproject.toml Pipfile)
  for f in $files; do
    [[ -f $f ]] && break
  done && {
    if [[ -n $CONDA_DEFAULT_ENV ]]; then
      echo " %{$fg_bold[yellow]%}$CONDA_DEFAULT_ENV%{$reset_color%}"
    elif [[ -n $VIRTUAL_ENV ]]; then
      echo " %{$fg_bold[yellow]%}$(basename $VIRTUAL_ENV)%{$reset_color%}"
    fi
  }
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

export PROMPT=$'\n$(directory_name) $(git_dirty)$(need_push)$(node_version)$(python_version)\n› '

precmd() {
  title "zsh" "%m" "%55<...<%~"
}
