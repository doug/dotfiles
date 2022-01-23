#!/usr/bin/env bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Explicit node path because nvm.sh is too slow for including in prompt
if [ -d $HOME/.nvm ]; then
  NODE_PATH=$(ls -d $HOME/.nvm/versions/node/* | tail -1)
  export PATH=$NODE_PATH/bin:$PATH
  # alias nvm="$HOME/.nvm/nvm.sh; nvm"
  nvm() { . "$HOME/.nvm/nvm.sh" ; nvm $@ ; }
fi

if [! -d $BASH_IT ]; then
  git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
  source $BASH_IT/bash_it.sh
  bash-it disable plugin all
  bash-it disable alias all
  bash-it disable completion all
  bash-it enable plugin base alias-completion extract git history tmux todo
  bash-it enable alias ag atom docker general git npm tmux todo vim
  bash-it enable completion bash-it docker git git_flow gulp npm pip ssh system tmux todo
  platform=`uname`
  if [[ "$platform" == "Linux" ]]; then
    bash-it enable alias apt clipboard
    bash-it enable completion brew
  elif [[ "$platform" == "Darwin" ]]; then
    bash-it enable plugin osx-timemachine osx
    bash-it enable alias homebrew-cask homebrew osx
  fi
fi

# Load Bash It
source $BASH_IT/bash_it.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[ -f ~/.commonrc ] && source ~/.commonrc

[ -f ~/.localrc ] && source ~/.localrc

# finished=`$gd +%s%3N`
# total=$((finished-started))
# echo "Took $total milliseconds."

# Unified history
shopt -s histappend
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

