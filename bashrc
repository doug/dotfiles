#!/usr/bin/env bash
# gd=/Users/dougfritz/.homebrew/bin/gdate
# started=`$gd +%s%3N`

# Google Cloud SDK completions.
if [ -d $HOME/bin/google-cloud-sdk ]; then
  source $HOME/bin/google-cloud-sdk/path.bash.inc
  source $HOME/bin/google-cloud-sdk/completion.bash.inc
fi

# bind "set completion-ignore-case on"
# bind "set show-all-if-ambiguous on"
# use inputrc instead

alias week="date +%Y-W%02V-%u"

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Homebrew
export HOMEBREW_PREFIX=$HOME/.homebrew
export HOMEBREW_CASK_OPTS="--caskroom=$HOME/.caskroom --binarydir=$HOME/bin"
export PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
export PKG_CONFIG_PATH=$HOMEBREW_PREFIX/lib:$HOMEBREW_PREFIX/include
export LD_LIBRARY_PATH=$HOMEBREW_PREFIX/lib
# git config --file="$(brew --repository)/.git/config" --replace-all homebrew.analyticsdisabled true
HOMEBREW_NO_ANALYTICS=1

export PATH=$HOME/bin:$PATH

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

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

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
source $BASH_IT/bash_it.sh

if [ -f $HOME/.localrc ]; then
  source $HOME/.localrc
fi

# finished=`$gd +%s%3N`
# total=$((finished-started))
# echo "Took $total milliseconds."
