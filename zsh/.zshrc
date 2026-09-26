# Skip if not interactive
[[ -o interactive ]] || return

# Keep PATH entries unique so nested shells don't pile up duplicates. This only
# applies to assignments to the `path` array; see the end of this file.
typeset -U path

# Check for required tools
for _tool in fzf starship zoxide; do
    if (( ! $+commands[$_tool] )); then
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
if [[ "$OSTYPE" == darwin* ]]; then
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
  local port="${1:-8080}"
  local opener
  [[ "$(uname)" == "Darwin" ]] && opener=open || opener=xdg-open
  # Open the browser after the server has had a moment to bind the port, then run
  # the server in the foreground so Ctrl-C stops it cleanly.
  ( sleep 1; "$opener" "http://localhost:$port/" ) &
  python3 -m http.server "$port"
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
    # Click a window to select it; libx264 requires even dimensions, so round down.
    local info w h x y
    info=$(xwininfo)
    w=$(awk '/Width:/  {print $2}'                <<< "$info")
    h=$(awk '/Height:/ {print $2}'                <<< "$info")
    x=$(awk '/Absolute upper-left X:/ {print $4}' <<< "$info")
    y=$(awk '/Absolute upper-left Y:/ {print $4}' <<< "$info")
    w=$(( w - w % 2 )); h=$(( h - h % 2 ))
    ffmpeg -f x11grab -s "${w}x${h}" -i ":0.0+${x},${y}" -r 25 -vcodec libx264 "$output"
  fi
}

function ai() {
  local name="${1:-ai}"
  local dir="${2:-.}"
  local ai_cmd="claude"

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

  # Create new session running AI fullscreen
  tmux new-session -d -s "$name" -n main -c "$dir" "$ai_cmd"

  # Attach or switch
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$name"
  else
    tmux attach-session -t "$name"
  fi
}

function dev() {
  local name="${1:-dev}"
  local dir="${2:-.}"
  local editor_cmd="nvim ."
  local ai_cmd="claude"

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
  tmux split-window -t "$name" -h -p 35 -c "$dir" "$ai_cmd"

  # Editor in left pane
  tmux send-keys -t "$name":main.0 "$editor_cmd" Enter

  # Focus AI pane
  tmux select-pane -t "$name":main.1

  # Attach or switch
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$name"
  else
    tmux attach-session -t "$name"
  fi
}

# For preview of markdown side by side in tmux and vim
function glowatch() {
  # If $1 is empty, default to "*.md". Otherwise, use $1.
  find . -name "${1:-*.md}" | entr -c glow /_
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

# Cache each tool's generated init script, keyed on the resolved binary path so
# an upgrade (which changes the Cellar/versioned path) regenerates it.
function _cached_init() {
  local name=$1 bin=${commands[$2]}
  shift
  [[ -n $bin ]] || return
  local cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/$name.zsh key="# ${bin:A}" line
  [[ -r $cache ]] && read -r line < $cache
  if [[ $line != $key ]]; then
    mkdir -p ${cache:h}
    { print -r -- $key; "$@" } >| $cache
  fi
  source $cache
}
_cached_init fzf fzf --zsh
_cached_init zoxide zoxide init zsh
_cached_init starship starship init zsh --print-full-init
unfunction _cached_init

# NVM: sourcing nvm.sh takes ~1s, so put the default node on PATH directly and
# only load nvm itself the first time it's used.
export NVM_DIR="$HOME/.nvm"
_nvm_sh=""
for _d in /opt/homebrew/opt/nvm /usr/local/opt/nvm $NVM_DIR; do
  [[ -s "$_d/nvm.sh" ]] && { _nvm_sh="$_d/nvm.sh"; break; }
done

if [[ -n "$_nvm_sh" ]]; then
  # Source under `emulate zsh` so nvm's functions keep default options when
  # called later: extendedglob turns `${x%%#*}` in nvm_alias into a bad pattern.
  function _nvm_load() {
    unfunction nvm nvm_ls _nvm_load
    emulate zsh -c '. "$_nvm_sh" --no-use'
    unset _nvm_sh
  }
  function nvm() { _nvm_load && nvm "$@" }
  function nvm_ls() { _nvm_load && nvm_ls "$@" }   # used by nvm's completion

  # Resolve the default alias (e.g. "24", "v24.14.0", "node") to the newest
  # matching installed version. Anything fancier (lts/*, nested aliases) falls
  # back to loading nvm now.
  _nvm_default=""
  [[ -r "$NVM_DIR/alias/default" ]] && read -r _nvm_default < "$NVM_DIR/alias/default"
  case $_nvm_default in
    node|stable) _nvm_bin=($NVM_DIR/versions/node/v*(N/nOn)) ;;
    v#<->*)      _nvm_bin=($NVM_DIR/versions/node/v${_nvm_default#v}(N/) \
                           $NVM_DIR/versions/node/v${_nvm_default#v}.*(N/nOn)) ;;
    *)           _nvm_bin=() ;;
  esac
  if (( $#_nvm_bin )); then
    path=("$_nvm_bin[1]/bin" $path)
    export NVM_BIN="$_nvm_bin[1]/bin" NVM_INC="$_nvm_bin[1]/include/node"
  elif [[ -n $_nvm_default ]]; then
    _nvm_load && nvm use --silent default
  fi

  _d=${_nvm_sh:h}
  for _c in $_d/etc/bash_completion.d/nvm $_d/bash_completion; do
    [[ -s $_c ]] && { source $_c; break; }
  done
fi
unset _nvm_default _nvm_bin _d _c

# User-installed CLIs (claude, uv tools, etc.)
path=("$HOME/.local/bin" $path)

# User-specific local configurations
[ -f ~/.localrc ] && source ~/.localrc

# Scalar PATH assignments (nvm, .localrc) bypass `typeset -U`; reassigning the
# array applies it.
path=($path)
