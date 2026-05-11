# grc overrides for ls - cross-platform

if command -v gls >/dev/null 2>&1; then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
elif command -v ls++ >/dev/null 2>&1; then
  alias ls="ls++"
  alias l="ls++ -lAh"
  alias ll="ls++ -l"
  alias la='ls++ -A'
else
  alias ls="ls -F --color=auto"
  alias l="ls -lAh"
  alias ll="ls -l"
  alias la='ls -A'
fi
