autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

node_version() {
  if (( $+commands[fnm] ))
  then
    echo "$(fnm current 2>/dev/null | sed 's/^v//')"
  elif (( $+commands[node] ))
  then
    echo "$(node --version 2>/dev/null | sed 's/^v//')"
  fi
}

python_env() {
  if [[ -n "$CONDA_DEFAULT_ENV" ]]
  then
    echo "conda:$CONDA_DEFAULT_ENV"
  elif [[ -n "$VIRTUAL_ENV" ]]
  then
    echo "venv:$(basename $VIRTUAL_ENV)"
  elif (( $+commands[pyenv] ))
  then
    echo "$(pyenv version-name 2>/dev/null)"
  fi
}

runtime_prompt() {
  local parts=()
  local nv="$(node_version)"
  local pv="$(python_env)"
  [[ -n "$nv" ]] && parts+="%{$fg_bold[green]%}node@$nv%{$reset_color%}"
  [[ -n "$pv" ]] && parts+="%{$fg_bold[yellow]%}$pv%{$reset_color%}"
  echo "${(j: :)parts}"
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

export PROMPT=$'\n$(directory_name) $(git_dirty)$(need_push) $(runtime_prompt)\n› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
