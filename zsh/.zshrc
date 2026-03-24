# Skip if not interactive
[[ -o interactive ]] || return

# Check for required tools
for _tool in fzf starship zoxide; do
    if ! command -v $_tool >/dev/null 2>&1; then
        echo "Warning: $_tool is not installed. Run install.sh or: brew install $_tool"
    fi
done
unset _tool


# - - - - - - - - - - - - - - - - - - - -
# ZSH Core
# - - - - - - - - - - - - - - - - - - - -

autoload -Uz compinit promptinit

# Regenerate completion dump daily
_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
    compinit -i -C
else
    compinit -i
fi
unset _comp_files
promptinit
setopt prompt_subst


# - - - - - - - - - - - - - - - - - - - -
# ZSH Settings
# - - - - - - - - - - - - - - - - - - - -

autoload -U colors && colors
unsetopt case_glob              # Case-insensitive globbing
setopt globdots                 # Glob dotfiles
setopt extendedglob             # Extended globbing
setopt autocd                   # cd by typing directory name

# Smart URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# General
setopt brace_ccl                # Brace character class list expansion
setopt combining_chars          # Combine zero-length punctuation characters
setopt rc_quotes                # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
unsetopt mail_warning           # No mail warnings

# Jobs
setopt long_list_jobs
setopt auto_resume
setopt notify
unsetopt bg_nice
unsetopt hup
unsetopt check_jobs

setopt correct                  # Command corrections

# Completion
setopt complete_in_word
setopt always_to_end
setopt path_dirs
setopt auto_menu
setopt auto_list
setopt auto_param_slash
setopt no_complete_aliases
setopt menu_complete
unsetopt flow_control

# Zstyle
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' rehash true

# History
HISTFILE="${ZDOTDIR:-$HOME}/.zhistory"
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory notify
unsetopt beep nomatch
setopt bang_hist
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_verify
setopt extended_history


# - - - - - - - - - - - - - - - - - - - -
# Aliases
# - - - - - - - - - - - - - - - - - - - -

# Neovim
if command -v nvim >/dev/null 2>&1; then
  alias vim=nvim
fi

# Platform-dependent
if [[ "$(uname)" == "Darwin" ]]; then
    alias ls="ls -G"
    alias flush="dscacheutil -flushcache"
    alias emptytrash="rm -rfv ~/.Trash"
    alias cleanup="find . -name '.DS_Store' -type f -ls -delete"
    alias show="defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder"
    alias hide="defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder"
    alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
    alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
    alias spotoff="sudo mdutil -a -i off"
    alias spoton="sudo mdutil -a -i on"
    alias localip="ipconfig getifaddr en0"
    alias sniff="sudo ngrep -d 'en0' -t '^(GET|POST) ' 'tcp and port 80'"
    alias httpdump="sudo tcpdump -i en0 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
    alias fs="stat -f '%z bytes'"
else
    alias ls="ls --color=auto"
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -selection clipboard -o"
    alias trash="gio trash"
    alias localip="hostname -I | awk '{print \$1}'"
    alias sniff="sudo ngrep -d 'any' -t '^(GET|POST) ' 'tcp and port 80'"
    alias httpdump="sudo tcpdump -i any -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
    alias fs="stat -c '%s bytes'"
fi

# Listing
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lsa='ls -lah'

# Git
alias s="git status"

# tmux attach or create session
alias ta='tmux new-session -A -s'

# Sound (requires sox)
alias noise="play -c 2 -n synth pinknoise band -n 2500 4000 reverb 20"
alias gamma="play -n synth sin 315 sin 365 remix 1 2"
alias beta="play -n synth sin 315 sin 340 remix 1 2"
alias alpha="play -n synth sin 315 sin 325 remix 1 2"
alias theta="play -n synth sin 315 sin 320 remix 1 2"
alias delta="play -n synth sin 315 sin 317 remix 1 2"
alias gammap="play -n synth sin 315 sin 365 pinknoise remix 1,3 2,3"
alias ocean="play -c 2 -r 41k -t sl - synth 60:00 brownnoise tremolo .13 70 < /dev/zero"
alias brown="play -c 2 -n synth 60:00 brownnoise"

# Network
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ and print $1'"
alias whois="whois -h whois-servers.net"
alias myip="curl https://api.ipify.org"

# Misc
alias week="date +%Y-W%V-%u"
alias home="cd $HOME"
alias encrypt="openssl aes-256-cbc"
alias decrypt="openssl aes-256-cbc -d"


# - - - - - - - - - - - - - - - - - - - -
# Functions
# - - - - - - - - - - - - - - - - - - - -

function server() {
  python3 -m http.server 8080 &
  if [[ "$(uname)" == "Darwin" ]]; then
    open http://localhost:8080/
  else
    xdg-open http://localhost:8080/
  fi
}

function digga() {
  dig +nocmd "$1" any +multiline +noall +answer
}

function md() {
  mkdir -p "$1"
  cd "$1"
}

function replace-all() {
  rg -0 -l "$1" | xargs -0 perl -pi -e "s/$1/$2/g"
}

function randpw() {
  dd if=/dev/urandom bs=1 count=16 2>/dev/null | base64 | rev | cut -b 2- | rev
}

function img() {
  local opts=(--format=kitty --scale=max --align=center --polite=on)
  [[ -n "$TMUX" ]] && opts+=(--passthrough=tmux)
  chafa "${opts[@]}" "$@"
}

function jjpush() {
  jj describe -m "$1" && jj bookmark set main -r @ && jj git push
}

function screenrecord {
  local output="${1:-$HOME/output.mkv}"
  if [[ "$(uname)" == "Darwin" ]]; then
    ffmpeg -f avfoundation -i "1:none" -r 25 -vcodec libx264 "$output"
  else
    ffmpeg -f x11grab -s $(xwininfo | grep 'geometry' | awk '{split($2,a,"+"); split(a[1],b,"x"); print b[1]-b[1]%2 "x" b[2]-b[2]%2 " -i :0.0+" a[2]-a[2]%2 "," a[3]-a[3]%2;}') -r 25 -vcodec libx264 "$output"
  fi
}

function dev() {
  local name="${1:-dev}"
  local dir="${2:-.}"

  # If session exists, attach to it
  if tmux has-session -t "$name" 2>/dev/null; then
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -t "$name"
    else
      tmux attach-session -t "$name"
    fi
    return
  fi

  # Resolve directory
  dir="$(cd "$dir" 2>/dev/null && pwd)" || { echo "Invalid directory: $2"; return 1; }

  # Create new session
  tmux new-session -d -s "$name" -n main -c "$dir"

  # Bottom terminal (fixed 5 lines)
  tmux split-window -t "$name" -v -l 5 -c "$dir"

  # AI on right (35% width of top pane)
  tmux select-pane -t "$name":main.0
  tmux split-window -t "$name" -h -p 35 -c "$dir" 'claude'

  # Helix in left pane
  tmux send-keys -t "$name":main.0 'hx .' Enter

  # Focus Claude pane
  tmux select-pane -t "$name":main.1

  # Attach or switch
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$name"
  else
    tmux attach-session -t "$name"
  fi
}


# - - - - - - - - - - - - - - - - - - - -
# FZF Functions
# - - - - - - - - - - - - - - - - - - - -

if command -v fzf >/dev/null 2>&1; then

  function fkill() {
      local pid
      if [ "$UID" != "0" ]; then
          pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
      else
          pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
      fi
      if [ "x$pid" != "x" ]; then
          echo $pid | xargs kill -${1:-9}
      fi
  }

  function fcd() {
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

  function fopen() {
    local out file key
    IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
    key=$(head -1 <<< "$out")
    file=$(head -2 <<< "$out" | tail -1)
    if [ -n "$file" ]; then
      [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
    fi
  }

  if command -v rg >/dev/null 2>&1; then
    function fcode() {
      local file
      file="$(rg --no-heading --line-number $@ | fzf -0 -1 | awk -F: '{print $1}')"
      if [[ -n $file ]]; then
        $EDITOR $file
      fi
    }
  fi

  if command -v brew >/dev/null 2>&1; then
    function bip() {
      local inst=$(brew search | fzf -m)
      if [[ $inst ]]; then
        for prog in $(echo $inst); do brew install $prog; done
      fi
    }
    function bup() {
      local upd=$(brew leaves | fzf -m)
      if [[ $upd ]]; then
        for prog in $(echo $upd); do brew upgrade $prog; done
      fi
    }
    function bcp() {
      local uninst=$(brew leaves | fzf -m)
      if [[ $uninst ]]; then
        for prog in $(echo $uninst); do brew uninstall $prog; done
      fi
    }
  fi

fi


# - - - - - - - - - - - - - - - - - - - -
# Tool Init (interactive only)
# - - - - - - - - - - - - - - - - - - - -

command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# NVM
export NVM_DIR="$HOME/.nvm"
if [[ "$(uname)" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
  [ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
  [ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"
else
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# User-specific local configurations
[ -f ~/.localrc ] && source ~/.localrc
