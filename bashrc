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

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Homebrew
if [ -d $HOME/.homebrew ]; then
  export HOMEBREW_PREFIX=$HOME/.homebrew
  export HOMEBREW_CASK_OPTS="--caskroom=$HOME/.caskroom --binarydir=$HOME/bin"
  export PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
  export PKG_CONFIG_PATH=$HOMEBREW_PREFIX/lib:$HOMEBREW_PREFIX/include
  export LD_LIBRARY_PATH=$HOMEBREW_PREFIX/lib
  # git config --file="$(brew --repository)/.git/config" --replace-all homebrew.analyticsdisabled true
  HOMEBREW_NO_ANALYTICS=1
else
  export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
fi

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

# Explicit node path because nvm.sh is too slow for including in prompt
if [ -d $HOME/.nvm ]; then
  NODE_PATH=$(ls -d $HOME/.nvm/versions/node/* | tail -1)
  export PATH=$PATH:$NODE_PATH/bin
  # alias nvm="$HOME/.nvm/nvm.sh; nvm"
  nvm() { . "$HOME/.nvm/nvm.sh" ; nvm $@ ; }
fi

# Git aliases
alias s="git status"

# Load Bash It
source $BASH_IT/bash_it.sh

# Aliases
if which gdate >/dev/null; then
  alias week="gdate +%Y-W%02V-%u"
else
  alias week="date +%Y-W%02V-%u"
fi

if which avconv >/dev/null; then
  alias ffmpeg="avconv"
fi

function screenrecord {
  ffmpeg -f x11grab -s $(xwininfo | grep 'geometry' | awk '{split($2,a,"+"); split(a[1],b,"x"); print b[1]-b[1]%2 "x" b[2]-b[2]%2 " -i :0.0+" a[2]-a[2]%2 "," a[3]-a[3]%2;}') -r 25 -vcodec libx264 ~/output.mkv
}


if [ -f $HOME/.localrc ]; then
  source $HOME/.localrc
fi

# finished=`$gd +%s%3N`
# total=$((finished-started))
# echo "Took $total milliseconds."
