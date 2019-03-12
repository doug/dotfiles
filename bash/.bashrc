#!/usr/bin/env bash
# gd=/Users/dougfritz/.homebrew/bin/gdate
# started=`$gd +%s%3N`

# If not running interactively don't do anything.
[[ $- == *i* ]] || return


# Google Cloud SDK completions.
if [ -d $HOME/bin/google-cloud-sdk ]; then
  source $HOME/bin/google-cloud-sdk/path.bash.inc
  source $HOME/bin/google-cloud-sdk/completion.bash.inc
fi

# bind "set completion-ignore-case on"
# bind "set show-all-if-ambiguous on"
# use inputrc instead

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Homebrew
if [ -d $HOME/.homebrew ]; then
  export HOMEBREW_PREFIX=$HOME/.homebrew
  export PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
  export PKG_CONFIG_PATH=$HOMEBREW_PREFIX/lib:$HOMEBREW_PREFIX/include
  export LD_LIBRARY_PATH=$HOMEBREW_PREFIX/lib
  # git config --file="$(brew --repository)/.git/config" --replace-all homebrew.analyticsdisabled true
  HOMEBREW_NO_ANALYTICS=1
else
  export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
fi

export PATH=$HOME/.local/bin:$HOME/bin:$PATH

# Editor
if which nvim >/dev/null; then
  alias vim=nvim
fi

if which code >/dev/null; then
  export EDITOR=code
else
  export EDITOR=vim
fi

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
# export BASH_IT_THEME='sexy'
export BASH_IT_THEME='powerline-multiline'
export THEME_CLOCK_FORMAT="%H:%M:%S"
export POWERLINE_LEFT_PROMPT="cwd"
export POWERLINE_RIGHT_PROMPT="battery clock"
# export POWERLINE_PROMPT_USER_INFO_MODE="sudo"

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"
alias tt="t view project"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Explicit node path because nvm.sh is too slow for including in prompt
if [ -d $HOME/.nvm ]; then
  NODE_PATH=$(ls -d $HOME/.nvm/versions/node/* | tail -1)
  export PATH=$NODE_PATH/bin:$PATH
  # alias nvm="$HOME/.nvm/nvm.sh; nvm"
  nvm() { . "$HOME/.nvm/nvm.sh" ; nvm $@ ; }
fi

# Git aliases
alias s="git status"

# Load Bash It
source $BASH_IT/bash_it.sh

# Aliases
alias week="date +%Y-W%V-%u"
alias home="cd $HOME"

if which avconv >/dev/null; then
  alias ffmpeg="avconv"
fi

function screenrecord {
  ffmpeg -f x11grab -s $(xwininfo | grep 'geometry' | awk '{split($2,a,"+"); split(a[1],b,"x"); print b[1]-b[1]%2 "x" b[2]-b[2]%2 " -i :0.0+" a[2]-a[2]%2 "," a[3]-a[3]%2;}') -r 25 -vcodec libx264 ~/output.mkv
}

if which fzf >/dev/null; then

  # fkill - kill processes - list only the ones you can kill. Modified the earlier script.
  function fkill() {
      local pid
      if [ "$UID" != "0" ]; then
          pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
      else
          pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
      fi

      if [ "x$pid" != "x" ]
      then
          echo $pid | xargs kill -${1:-9}
      fi
  }

  function cd() {
      if [[ "$#" != 0 ]]; then
          builtin cd "$@";
          return
      fi
      while true; do
          local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
          local dir="$(printf '%s\n' "${lsd[@]}" |
              fzf --reverse --preview '
                  __cd_nxt="$(echo {})";
                  __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                  echo $__cd_path;
                  echo;
                  ls -p "${__cd_path}";
          ')"
          [[ ${#dir} != 0 ]] || return 0
          builtin cd "$dir" &> /dev/null
      done
  }

  # Modified version where you can press
  #   - CTRL-O to open with `open` command,
  #   - CTRL-E or Enter key to open with the $EDITOR
  function fo() {
    local out file key
    IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
    key=$(head -1 <<< "$out")
    file=$(head -2 <<< "$out" | tail -1)
    if [ -n "$file" ]; then
      [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
    fi
  }

  if which ag >/dev/null; then
    function fc() {
      local file
      file="$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1}')"
      if [[ -n $file ]]
      then
        $EDITOR $file
      fi
    }
  fi

  if which brew >/dev/null; then

    # Install (one or multiple) selected application(s)
    # using "brew search" as source input
    # mnemonic [B]rew [I]nstall [P]lugin
    function bip() {
      local inst=$(brew search | fzf -m)

      if [[ $inst ]]; then
        for prog in $(echo $inst); do
          brew install $prog
        done
      fi
    }
    # Update (one or multiple) selected application(s)
    # mnemonic [B]rew [U]pdate [P]lugin
    function bup() {
      local upd=$(brew leaves | fzf -m)

      if [[ $upd ]]; then
        for prog in $(echo $upd); do
          brew upgrade $prog
        done
      fi
    }
    # Delete (one or multiple) selected application(s)
    # mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
    function bcp() {
      local uninst=$(brew leaves | fzf -m)

      if [[ $uninst ]]; then
        for prog in $(echo $uninst); do
          brew uninstall $prog
        done
      fi
    }

  fi

fi

# if [ -f $HOME/virtualenv/tensorflow/bin/activate ]; then
#   source $HOME/virtualenv/tensorflow/bin/activate
# fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -f $HOME/.localrc ]; then
  source $HOME/.localrc
fi

# finished=`$gd +%s%3N`
# total=$((finished-started))
# echo "Took $total milliseconds."

