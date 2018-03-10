# Use vi mode ###########################################################
if type -q fish_vi_key_bindings
  fish_vi_key_bindings
end

# Set local vars ########################################################
set -x PATH $HOME/bin $PATH

set -x GOPATH $HOME/go
set -x PATH $GOPATH/bin $PATH

set -x EDITOR vim

if test -e $HOME/bin/android-sdk
  set -x ANDROID_SDK $HOME/bin/android-sdk
  set -x PATH $ANDROID_SDK/platform-tools $ANDROID_SDK/tools $PATH
end

if test -e $HOME/bin/google-cloud-sdk
  set -x PATH $HOME/bin/google-cloud-sdk/bin $PATH
end

if test -d $HOME/.nvm
  # proper nvm import
  # bass source $HOME/.nvm/nvm.sh
  # fast import
  set -x NVM_DIR $HOME/.nvm
  set NVM_VERSION (ls $NVM_DIR/versions/node)
  set NVM_VERSION $NVM_DIR/versions/node/$NVM_VERSION[(count $NVM_VERSION)]
  set -x NVM_BIN $NVM_VERSION/bin
  set -x NVM_PATH $NVM_VERSION/lib/node
  set -x PATH $NVM_BIN $PATH
  set -x MANPATH $NVM_VERSION/share/man $MANPATH
end

# Platform dependent ####################################################
switch (uname)
  case Darwin
    set -x HOMEBREW_CASK_OPTS "--caskroom=$HOME/.caskroom --binarydir=$HOME/bin"
    set -x HOMEBREW_PREFIX $HOME/.homebrew
    set -x PATH $HOMEBREW_PREFIX/bin $PATH

    set -x PKG_CONFIG_PATH $PKG_CONFIG_PATH $HOMEBREW_PREFIX/lib $HOMEBREW_PREFIX/include
    set -x C_INCLUDE_PATH $C_INCLUDE_PATH $HOMEBREW_PREFIX/include
    set -x CPP_INCLUDE_PATH $CPP_INCLUDE_PATH $HOMEBREW_PREFIX/include
    set -x LIBRARY_PATH $LIBRARY_PATH $HOMEBREW_PREFIX/lib
    set -x LD_LIBRARY_PATH $LD_LIBRARY_PATH $HOMEBREW_PREFIX/lib

    alias signalstrength="while true; /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep CtlRSSI | sed -e 's/^.*://g' | xargs -I SIGNAL printf \"\rRSSI dBm: SIGNAL\"; sleep 0.5; end"

    # Flush Directory Service cache
    alias flush="dscacheutil -flushcache"

    # Empty the Trash
    alias emptytrash="rm -rfv ~/.Trash"

    # Recursively delete `.DS_Store` files
    alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

    # Show/hide hidden files in Finder
    alias show="defaults write com.apple.Finder AppleShowAllFiles -bool true and killall Finder"
    alias hide="defaults write com.apple.Finder AppleShowAllFiles -bool false and killall Finder"

    # Hide/show all desktop icons (useful when presenting)
    alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false and killall Finder"
    alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true and killall Finder"

    # Disable Spotlight
    alias spotoff="sudo mdutil -a -i off"
    # Enable Spotlight
    alias spoton="sudo mdutil -a -i on"

  case Linux
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -selection clipboard -o"
    # alias open="xdg-open" # open is native in fish
    alias trash="gvfs-trash"
end

# Useful aliases ########################################################
alias s "git status"

alias noise "play -c 2 -n synth pinknoise band -n 2500 4000 reverb 20"
alias gamma "play -n synth sin 315 sin 365 remix 1 2"
alias beta "play -n synth sin 315 sin 340 remix 1 2"
alias alpha "play -n synth sin 315 sin 325 remix 1 2"
alias theta "play -n synth sin 315 sin 320 remix 1 2"
alias delta "play -n synth sin 315 sin 317 remix 1 2"
alias gammap "play -n synth sin 315 sin 365 pinknoise remix 1,3 2,3"
alias ocean "play -c 2 -r 41k -t sl - synth $len brownnoise tremolo .13 70 < /dev/zero"
alias brown "hplay -c 2 -n synth 60:00 brownnoise"

# Useful abbreviations ##################################################
if type -q abbr
  abbr -a gco git checkout
end

#################################
### Network Related
#################################

alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ and print $1'"
alias whois="whois -h whois-servers.net"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

function server --description "Start an HTTP server from a directory"
  open http://localhost:8080/
  and python -m SimpleHTTPServer 8080
end

function digga --description "All the dig info"
  dig +nocmd $argv[1] any +multiline +noall +answer
end

alias myip="curl ip.appspot.com"

################################
###  Unix Related
################################
# File size
alias fs="stat -f \"%z bytes\""

function md
  mkdir -p "$argv"; cd "$argv"
end

function randpw --description "generate a random password"
  dd if=/dev/urandom bs=1 count=16 2>/dev/null | base64 | rev | cut -b 2- | rev
end

function cd --description "auto ls for each cd"
  if [ -n $argv[1] ]
    builtin cd $argv[1]
    and ls -AF
  else
    builtin cd ~
    and ls -AF
  end
end

alias encrypt="openssl aes-256-cbc"
alias decrypt="openssl aes-256-cbc -d"


# Fish greeting #########################################################

if type -q fortune
  function fish_greeting
    fortune -s
  end
else
  set fish_greeting
end

# Fish git prompt #######################################################
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'

function fish_prompt
  set last_status $status

  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s ' (__fish_git_prompt)
  set_color normal
end

if test -e $HOME/.local.fish
    . $HOME/.local.fish
end
