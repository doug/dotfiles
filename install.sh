#!/bin/bash

platform=`uname`

if [[ "$platform" == "Linux" || "$platform" == "Darwin" ]]; then

  current=$(cd $(dirname "$0") && pwd)
  echo $current

  echo "Update symlinked dotfiles (.bashrc .vimrc, .tmux.conf, ...)? [yN]"
  read symlinks
  if [[ "$symlinks" =~ ^[Yy]$ ]]; then

    pushd $HOME/dotfiles
    stow bash vim tmux
    popd

    echo "----"
    mkdir -p $HOME/.config/fish/functions
    for fishfn in config/fish/functions/*; do
      echo "Linking $fishfn to $HOME/.$fishfn"
      ln -fns "$current/$fishfn" "$HOME/.$fishfn"
    done

    echo "----"
    mkdir -p $HOME/bin
    binfiles=()
    for binfile in "${binfiles[@]}"; do
      echo "Linking $binfile to $HOME/bin/$binfile"
      ln -fns "$current/$binfile" "$HOME/bin/$binfile"
      chmod +x "$HOME/bin/$binfile"
    done
  fi

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

    if [[ ! -d $HOME/.homebrew ]]; then
      echo "Install homebrew? [yN] "
      read homebrew
      if [[ "$homebrew" =~ ^[Yy]$ ]]; then
        mkdir $HOME/.homebrew && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
        export PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH
        brew install caskroom/cask/brew-cask
      fi
    fi

    echo "Install default Apps? (Chrome, Spectacle, ... ) [yN] "
    read apps
    if [[ "$apps" =~ ^[Yy]$ ]]; then
      if command -v brew-cask >/dev/null 2>&1; then
        brew cask install google-chrome
        brew cask install spectacle
      else
        echo 'Must have homebrew installed, rerun this script.'
      fi
    fi
  fi

  echo "Install additional fonts? [yN]"
  read fonts
  if [[ "$fonts" =~ ^[Yy]$ ]]; then
    # Google Fonts
    sh "$current/download-fonts.sh"
  fi

  echo "Update gitconfig.local? [yN] "
  read gitconfig
  if [[ "$gitconfig" =~ ^[Yy]$ ]]; then
    # reset .gitconfig.local
    echo > $HOME/.gitconfig.local
    git config -f $HOME/.gitconfig.local http.cookiefile $HOME/.gitcookies
    echo "Your name: "
    read name
    git config -f $HOME/.gitconfig.local user.name $name
    echo "Your email: "
    read email
    git config -f $HOME/.gitconfig.local user.email $email
    echo "Github username: "
    read github
    git config -f $HOME/.gitconfig.local github.user $github
    if [[ "$platform" == "Linux" ]]; then
      git config -f $HOME/.gitconfig.local credential.helper cache
    elif [[ "$platform" == "Darwin" ]]; then
      git config -f $HOME/.gitconfig.local credential.helper osxkeychain
    fi
  fi

  echo "Install base packages? [yN] "
  read base
  if [[ "$base" =~ ^[Yy]$ ]]; then
    if [[ "$platform" == "Linux" ]]; then
      if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get -y install git
        sudo apt-get -y install git-extras
        sudo apt-get -y install build-essential
        sudo apt-get -y install exuberant-ctags
        sudo apt-get -y install libclang-dev
        sudo apt-get -y install tmux
        sudo apt-get -y install vim
        sudo apt-get -y install fish
        sudo apt-get -y install silversearcher-ag
        sudo apt-get -y install ffmpeg
        sudo apt-get -y install imagemagick
      elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S git git-extras vim neovim tmux build-essential
        exuberant-ctags libclang-dev fish silversearcher-ag ffmpeg imagemagick
      else
        echo 'unknown package manager.'
      fi
    elif [[ "$platform" == "Darwin" ]]; then
      if command -v brew >/dev/null 2>&1; then
        brew install git
        brew install git-extras
        brew install wget
        brew install tmux
        brew install ctags
        brew install macvim --with-override-system-vim
        # tmux pasteboard fixes issue of copy/paste from tmux
        brew install reattach-to-user-namespace
        brew install fish
        brew install the_silver_searcher
        brew install ios-webkit-debug-proxy
        brew install ffmpeg
        brew install imagemagick
      else
        echo 'Must have homebrew installed, rerun this script.'
      fi
    fi
  fi


  if [[ ! -d $HOME/.tmux ]]; then
    echo "Install tmux plugins? [yN] "
    read tmux
    if [[ "$tmux" =~ ^[Yy]$ ]]; then
      git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    fi
  fi

  echo "All finished, please reload your terminal."

fi
