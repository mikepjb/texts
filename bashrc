shopt -s nocaseglob #case insensitive completion

OS="Linux"

detect_os() {
  desc=$(uname -a)

  if [[ $desc == *"microsoft-standard-WSL2"* ]]; then
    OS="Windows"
  elif [[ $desc = *"Darwin"* ]]; then
    OS="Mac"
  fi
}

detect_os

[ -f /etc/bash_completion ] && . /etc/bash_completion
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
[[ $- =~ i ]] && stty -ixoff -ixon # Disable CTRL-S and CTRL-Q

join_by() { local IFS="$1"; shift; echo "$*"; }

path_dirs=(
  /opt/homebrew/bin
  $HOME/.config/n/bin
  /usr/local/bin
  /usr/local/sbin
  /bin
  /sbin
  $HOME/.config/nvim/bin
  /usr/local/opt/node@16/bin
  /opt/homebrew/opt/node@16/bin
  $HOME/.local/share/nvim/site/pack/packer/opt/vim-iced/bin
  $HOME/.config/npm/bin
  $HOME/.local/bin
  $HOME/bin
  /usr/bin
  /usr/sbin
  $HOME/go/bin
)

export PATH=$(join_by : "${path_dirs[@]}")
export CDPATH=".:$HOME/src"
export GOPATH=$HOME/go
export EDITOR=nvim
export HISTCONTROL=erasedups
export HISTSIZE=10000
# this causes issues when using clojure, it defaults the .clojure to .config/clojure
# export XDG_CONFIG_HOME=$HOME/.config # should only be set for linux..
export PAGER='less -S'
export SSH_AUTH_SOCK=$HOME/.ssh/ssh-agent.socket
export NPM_CONFIG_PREFIX=$HOME/.config/npm
export GEM_HOME=$HOME/.config/gems
export N_PREFIX=$HOME/.config/n

alias gr='cd $(git rev-parse --show-toplevel || echo ".")'
alias ..='cd ..'
alias s="config_sync && echo 'Reloading shell..' && source $HOME/.bashrc"
alias x='tmux attach -t vty || tmux new -s vty'
alias de='export $(egrep -v "^#" .env | xargs)'
alias xclip='xclip -sel clip'
alias jv="jq -C | less -R"
alias ssha="ssh-agent -a $SSH_AUTH_SOCK && ssh-add ~/.ssh/id_rsa"
# alias open='xdg-open' # only for linux
alias vi='nvim'
alias nm='neomutt'
alias get-music='yt-dlp --extract-audio --audio-format m4a'
alias rkb='xset r rate 200 25 && setxkbmap -layout us -option ctrl:nocaps'
alias pg='pg_ctl -D /usr/local/var/postgres' # start/stop
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias nr='npm run'
alias cds='cd ~/.config/nvim' # cd => setup
alias t='config_todo_list'
alias focus='play -n synth brownnoise synth pinknoise mix synth sine amod 0.1 20 gain -20'

gxi() { grep -r --color=always --exclude-dir={web-target,.clj-kondo,node_modules,out,target} "$@"; }
gx() { gxi "$@" | less -R; }
alias gxl='gx -l'

viw() { vi `which "$1"`; }
pp() { until ping -c1 1.1.1.1 >/dev/null 2>&1; do :; done; }
git_branch() { echo -e "$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')"; }

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

inside_git_repo() {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

# TODO does not list files that the match comes from
config_todo_list() {
  if inside_git_repo; then
    git ls-files | xargs grep -h "\(TODO\|NEXT\|XXX\)" 2>/dev/null
  else
    grep -rh "\(TODO\|NEXT\|XXX\)" $HOME/.notes 2>/dev/null
  fi
}

config_todo_count() {
  local n=$(config_todo_list | wc -l)
  # also.. would be kinda cool to have a TODOs tool in vim to jump to next etc
  # also ISO dates are sortable as strings so perhaps having them too implements a poor mans schedule/deadline
  # but we miss out on +1y/repeatable tasks
  ((n)) && echo -n $n || echo -n '0'
}

# PROMPT_COMMAND='PS1="\W($(git_state):$(config_todo_count)) $(jobs_marker) "'
PROMPT_COMMAND='PS1="\W($(git_state)) $(jobs_marker) "'

if [ "$OS" = "Mac" ]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
  export JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home}"
  # this breaks .clojure/deps.edn, why did we do this again?
  # export XDG_CONFIG_HOME=$HOME/.config
fi

if [ -f "$HOME/.bashrc.local" ]; then
  source "$HOME/.bashrc.local"
fi
