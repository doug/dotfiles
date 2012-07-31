# don't auto update oh-my-zsh
export DISABLE_AUTO_UPDATE=true

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="skaro"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Detect os
platform=`uname`

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)

plugins=(git github git-flow pip npm python gem)
if [[ "$platform"  == "Darwin" ]]; then
  plugins+=(osx brew)
  # OSX Aliases
  alias gvim=mvim
  alias python32="arch -i386 python"
  # Homebrew
  export HOMEBREW_PREFIX=/usr/local
  export PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
  # GO
  export GOROOT=`brew --prefix go`
  export GOBIN=$HOMEBREW_PREFIX/bin
  export GOARCH=amd64
  export GOOS=darwin
  # pkg-config
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/lib:$HOMEBREW_PREFIX/include
  # Appengine
  export APPENGINE_SDK_HOME=`brew --prefix app-engine-java-sdk`/libexec
  export APPENGINE_HOME=$APPENGINE_SDK_HOME
elif [[ "$platform" == "Linux" ]]; then
  plugins+=(deb debian)
fi

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Add home bin
export PATH=$PATH:$HOME/bin

# don't use cdablevars
unsetopt cdablevarS

[[ -f $HOME/.useful-extras.sh ]] && source $HOME/.useful-extras.sh

alias s="nocorrect git status"
alias noise="play -c 2 -n synth pinknoise band -n 2500 4000 reverb 20"
alias gamma="play -c 2 -n synth pinknoise band -n 315 365 reverb 20"
alias beta="play -c 2 -n synth pinknoise band -n 315 340 reverb 20"
alias alpha="play -c 2 -n synth pinknoise band -n 315 325 reverb 20"
alias theta="play -c 2 -n synth pinknoise band -n 315 320 reverb 20"
alias delta="play -c 2 -n synth pinknoise band -n 315 317 reverb 20"
alias ocean="play -c 2 -r 41k -t sl - synth $len brownnoise tremolo .13 70 < /dev/zero"
alias brown="play -c 2 -n synth 60:00 brownnoise"
#play -n synth 2 sin 440-880 fade h 2 gain -5 : synth 2 sin 880-660 gain -5
#play -r 32000 -t sl - synth $len pinknoise band -n 600 400 tremolo 20 .1 < /dev/zero
#play -c 2 -n synth pinknoise band -n 2500 4000 reverb 20
# play -m "|sox -n -p synth sin " "|sox -n -p synth 2 tremolo 10" "|sox -n -p synth pinknoise band -n 2500 4000 reverb 20"

export EDITOR=vim

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc # pythonbrew https://github.com/utahta/pythonbrew

# use .localrc for settings specific to one system
[[ -f $HOME/.localrc ]] && source $HOME/.localrc


