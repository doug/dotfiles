#!/bin/bash

platform=$(uname)

if [[ "$platform" == "Linux" || "$platform" == "Darwin" ]]; then

  current=$(cd "$(dirname "$0")" && pwd)
  echo "$current"

  if [[ "$platform" == "Linux" ]]; then
    echo "Setting up Linux"
    echo "Set better ubuntu defaults? [yN] "
    read ubuntu
    if [[ "$ubuntu" =~ ^[Yy]$ ]]; then
      sh "$current/ubuntu"
    fi
  elif [[ "$platform" == "Darwin" ]]; then
    echo "Setting up Mac"
    echo "Set better osx defaults? [yN] "
    read osx
    if [[ "$osx" =~ ^[Yy]$ ]]; then
      sh "$current/osx"
    fi

    if ! command -v brew >/dev/null 2>&1; then
      echo "Install homebrew? [yN] "
      read homebrew
      if [[ "$homebrew" =~ ^[Yy]$ ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    fi
  fi

  echo "Install packages? [yN] "
  read packages
  if [[ "$packages" =~ ^[Yy]$ ]]; then
    if [[ "$platform" == "Linux" ]]; then
      if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get -y install git build-essential libclang-dev \
          tmux vim neovim mosh stow ripgrep fzf ffmpeg imagemagick podman uv
      elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S git vim tmux base-devel \
          libclang-dev stow neovim helix mosh ripgrep fzf starship zoxide ffmpeg imagemagick podman uv
      else
        echo 'unknown package manager.'
      fi
      # starship and zoxide are not in default apt repos, install via official scripts
      if command -v apt-get >/dev/null 2>&1; then
        if ! command -v starship >/dev/null 2>&1; then
          curl -sS https://starship.rs/install.sh | sh
        fi
        if ! command -v zoxide >/dev/null 2>&1; then
          curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
        fi
        if ! command -v hx >/dev/null 2>&1; then
          sudo add-apt-repository -y ppa:maveonair/helix-editor
          sudo apt-get update
          sudo apt-get -y install helix
        fi
      fi
      # jj is not in apt/pacman, install via cargo
      if ! command -v jj >/dev/null 2>&1 && command -v cargo >/dev/null 2>&1; then
        cargo install jj-cli
      fi
      # nvm is not available via apt/pacman, install via official script
      if ! command -v nvm >/dev/null 2>&1 && [[ ! -d "$HOME/.nvm" ]]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        . "$NVM_DIR/nvm.sh"
        nvm install --lts
        nvm use --lts
      fi
    elif [[ "$platform" == "Darwin" ]]; then
      if command -v brew >/dev/null 2>&1; then
        nvm_was_missing=false
        if [[ ! -d "$HOME/.nvm" ]] && ! command -v nvm >/dev/null 2>&1; then
          nvm_was_missing=true
        fi
        brew install git wget tmux stow neovim helix jj mosh ripgrep fzf starship zoxide ffmpeg imagemagick podman uv nvm claude-code
        brew install --cask google-chrome vscodium ghostty tailscale
        if [[ "$nvm_was_missing" == true ]]; then
          export NVM_DIR="$HOME/.nvm"
          . "$(brew --prefix nvm)/nvm.sh"
          nvm install --lts
          nvm use --lts
        fi
      else
        echo 'Must have homebrew installed, rerun this script.'
      fi
    fi
    # Install podman-compose via uv
    if command -v uv >/dev/null 2>&1 && ! command -v podman-compose >/dev/null 2>&1; then
      uv tool install podman-compose
    fi
  fi

  if ! command -v go >/dev/null 2>&1; then
    echo "Install Go? [yN] "
    read golang
    if [[ "$golang" =~ ^[Yy]$ ]]; then
      if [[ "$platform" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
        brew install go
      elif [[ "$platform" == "Linux" ]]; then
        if command -v apt-get >/dev/null 2>&1; then
          sudo apt-get -y install golang
        elif command -v pacman >/dev/null 2>&1; then
          sudo pacman -S go
        fi
      fi
    fi
  fi

  if ! command -v rustup >/dev/null 2>&1; then
    echo "Install Rust (via rustup)? [yN] "
    read rust
    if [[ "$rust" =~ ^[Yy]$ ]]; then
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
  fi

  echo "Update symlinked dotfiles (.zshrc, .vimrc, .tmux.conf, .gitconfig, ...)? [yN]"
  read symlinks
  if [[ "$symlinks" =~ ^[Yy]$ ]]; then
    pushd "$HOME/.dotfiles"
    stow_packages=(zsh vim tmux git ghostty helix claude gemini)
    if [[ "$platform" == "Linux" ]]; then
      stow_packages+=(i3 linux conky)
    fi
    if ! stow "${stow_packages[@]}" 2>/tmp/stow_err; then
      cat /tmp/stow_err
      echo "Stow failed due to conflicts. Force overwrite existing files? [yN]"
      read force
      if [[ "$force" =~ ^[Yy]$ ]]; then
        stow --adopt "${stow_packages[@]}"
        git checkout -- "${stow_packages[@]}"
      fi
    fi
    popd
  fi

  echo "Install Nerd Fonts? (JetBrains Mono, Fira Code) [yN]"
  read fonts
  if [[ "$fonts" =~ ^[Yy]$ ]]; then
    NERD_FONTS=(JetBrains-Mono Fira-Code Iosevka)
    if [[ "$platform" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
      for font in "${NERD_FONTS[@]}"; do
        lower=$(echo "$font" | tr '[:upper:]' '[:lower:]')
        brew install --cask "font-${lower}-nerd-font"
      done
    elif [[ "$platform" == "Linux" ]]; then
      if command -v pacman >/dev/null 2>&1; then
        for font in "${NERD_FONTS[@]}"; do
          lower=$(echo "$font" | tr '[:upper:]' '[:lower:]')
          sudo pacman -S "ttf-${lower}-nerd"
        done
      else
        FONTDIR="$HOME/.local/share/fonts"
        mkdir -p "$FONTDIR"
        for font in "${NERD_FONTS[@]}"; do
          echo "Downloading $font Nerd Font..."
          curl -fsSL -o "/tmp/${font}.tar.xz" \
            "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz"
          tar -xf "/tmp/${font}.tar.xz" -C "$FONTDIR"
          rm "/tmp/${font}.tar.xz"
        done
        fc-cache -fv
      fi
    fi
  fi

  echo "Update gitconfig.local? [yN] "
  read gitconfig
  if [[ "$gitconfig" =~ ^[Yy]$ ]]; then
    echo > "$HOME/.gitconfig.local"
    git config -f "$HOME/.gitconfig.local" http.cookiefile "$HOME/.gitcookies"
    echo "Your name: "
    read name
    git config -f "$HOME/.gitconfig.local" user.name "$name"
    echo "Your email: "
    read email
    git config -f "$HOME/.gitconfig.local" user.email "$email"
    echo "Github username: "
    read github
    git config -f "$HOME/.gitconfig.local" github.user "$github"
    if [[ "$platform" == "Linux" ]]; then
      git config -f "$HOME/.gitconfig.local" credential.helper cache
    elif [[ "$platform" == "Darwin" ]]; then
      git config -f "$HOME/.gitconfig.local" credential.helper osxkeychain
    fi
  fi

  if [[ ! -d "$HOME/.tmux" ]]; then
    echo "Install tmux plugins? [yN] "
    read tmux
    if [[ "$tmux" =~ ^[Yy]$ ]]; then
      git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
  fi

  echo "All finished, please reload your terminal."

fi
