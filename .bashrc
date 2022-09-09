shopt -s nocaseglob #case insensitive completion
[[ $- =~ i ]] && stty -ixoff -ixon # Disable CTRL-S and CTRL-Q
[ -f /etc/bash_completion ] && . /etc/bash_completion
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
[ `command -v brew` ] && [ -f $(brew --prefix)/etc/bash_completion ] && . $(brew --prefix)/etc/bash_completion

path_dirs=(
  /opt/homebrew/bin
  /usr/local/bin
  /usr/local/sbin
  /bin
  /sbin
  /usr/local/opt/node@16/bin
  /opt/homebrew/opt/node@16/bin
  $HOME/.local/share/nvim/site/pack/packer/opt/vim-iced/bin
  $HOME/.config/npm/bin
  /opt/homebrew/bin
  $HOME/.local/bin
  $HOME/bin
  /usr/bin
  /usr/sbin
  $HOME/go/bin
)

join_by() { local IFS="$1"; shift; echo "$*"; }
export PATH=$(join_by : "${path_dirs[@]}")
export CDPATH=".:$HOME/src"
export EDITOR=nvim
export HISTCONTROL=erasedups
export HISTSIZE=10000

alias gr='cd $(git rev-parse --show-toplevel || echo ".")'
alias ..='cd ..'
alias x='cd ~/.config/nvim'
alias vi='nvim'
alias nr='npm run'
viw() { vi `which "$1"`; }

git_state() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        echo -ne "$(git_branch)"
    else
        echo -ne "!"
    fi
}

jobs_marker() {
  local n=$(jobs | wc -l)
  ((n)) && echo -n '&' || echo -n '$'
}

PROMPT_COMMAND='PS1="\W($(git_state)) $(jobs_marker) "'

if [ -f "$HOME/.bashrc.local" ]; then
  source "$HOME/.bashrc.local"
fi
