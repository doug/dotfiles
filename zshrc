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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew pip gem osx git-flow)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# don't use cdablevars
unsetopt cdablevarS

[[ -f $HOME/.useful-extras.sh ]] && source $HOME/.useful-extras.sh

# Aliases
alias gvim=mvim
alias python32="arch -i386 python"
alias s="nocorrect git status"

export HOMEBREW_PREFIX=/usr/local
export PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH

export EDITOR=vim

# Python from brew
export PATH=$HOMEBREW_PREFIX/share/python:$PATH

# JAVA
export JAVA_HOME=$(/usr/libexec/java_home)

# GO
export GOROOT=`brew --prefix go`
export GOBIN=$HOMEBREW_PREFIX/bin
export GOARCH=amd64
export GOOS=darwin
#export GOPATH=""

# NACL
export NACL_SDK_ROOT=/usr/local/Cellar/native-client-sdk/0.5

# NODE
export NODE_PATH=/Users/dougfritz/Homebrew/lib/node

# Python virtualenv
#source $HOME/.python2.7/bin/activate
#export PYTHONPATH=$HOME/.python2.7
# Python
export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH

# NPM
export PATH=$HOMEBREW_PREFIX/share/npm/bin:$PATH

# Clojure
export CLASSPATH=$CLASSPATH:$HOMEBREW_PREFIX/Cellar/clojure-contrib/1.2.0/clojure-contrib.jar

# Cljr
export PATH=$PATH:$HOME/.cljr/bin

# pkg-config
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/lib:$HOMEBREW_PREFIX/include

# Depot_tools
export PATH=/Users/dougfritz/src/goog/depot_tools:$PATH

# sbt-appengine-plugin
export JREBEL_JAR_PATH=/Applications/ZeroTurnaround/JRebel/jrebel.jar

# Appengine
export APPENGINE_SDK_HOME=`brew --prefix app-engine-java-sdk`/libexec
export APPENGINE_HOME=$APPENGINE_SDK_HOME

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc # pythonbrew https://github.com/utahta/pythonbrew

# use .localrc for settings specific to one system
[[ -f $HOME/.localrc ]] && source $HOME/.localrc

[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc

