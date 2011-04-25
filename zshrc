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
plugins=(git brew pip gem osx)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

[[ -f $HOME/.useful-extras.sh ]] && source $HOME/.useful-extras.sh

alias gvim=mvim

export HOMEBREW_PREFIX=$HOME/.homebrew
export PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
export EDITOR=mvim

# Clojure
export CLASSPATH=$CLASSPATH:$HOMEBREW_PREFIX/Cellar/clojure-contrib/1.2.0/clojure-contrib.jar

# Appengine
export APPENGINE_SDK_HOME=`brew --prefix app-engine-java-sdk`/libexec

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

# use .localrc for settings specific to one system
[[ -f $HOME/.localrc ]] && source $HOME/.localrc

