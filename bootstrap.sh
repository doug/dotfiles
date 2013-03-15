#!/usr/bin/env zsh

#Be sure to change your shell first
#chsh -s `which zsh`

platform=`uname`

if [[ "$platform" == "Linux" || "$platform" == "Darwin" ]]; then

  current=$(dirname "$0:A" )

  if [[ "$platform" == "Linux" ]]; then
    echo "Setting up Linux"
  elif [[ "$platform" == "Darwin" ]]; then
    echo "Setting up Mac"
    read "osx?Set new osx defaults? [yN] "
    if [[ "$osx" =~ ^[Yy]$ ]]; then
      zsh "$current/osx"
    fi
    if [[ ! -d /Applications/Spectacle.app ]]; then
      curl http://spectacleapp.com/updates/downloads/Spectacle%200.7.zip > spectacle.zip
      unzip spectacle.zip
      mv Spectacle.app /Applications
      rm spectacle.zip
    fi
    if [[ ! -d $HOME/.homebrew ]]; then
      mkdir $HOME/.homebrew && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
    fi
    # echo $HOME/.homebrew/bin > /etc/paths.d/homebrew
  fi

  # install prezto
  if [[ ! -d $HOME/.zprezto ]]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  fi

  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^(README.md|zshrc|zpreztorc)(.); do
    ln -fns "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    echo "Linking $rcfile to ${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done

  for rcfile in "${current}"/^(bootstrap.sh|*.template)*; do
    ln -fns "$rcfile" "$HOME/.${rcfile:t}"
    echo "Linking $rcfile to $HOME/.${rcfile:t}"
  done

  if [[ "$platform" == "Linux" ]]; then
    git config --global credential.helper cached
  elif [[ "$platform" == "Darwin" ]]; then
    git config --global credential.helper osxkeychain
  fi

  read "gitconfig?Update gitconfig? [yN] "
  if [[ "$gitconfig" =~ ^[Yy]$ ]]; then
    cp -f $current/gitconfig.template $HOME/.gitconfig
    read "name?Your name: "
    git config --global user.name $name
    read "email?Your email: "
    git config --global user.email $email
    read "github?Github username: "
    git config --global github.user $github
  fi

  read "base?Install base packages? [yN] "
  if [[ "$base" =~ ^[Yy]$ ]]; then
    if [[ "$platform" == "Linux" ]]; then
      sudo apt-get install git
      sudo apt-get install build-essential
      sudo apt-get install ffmpeg
      sudo apt-get install node
      sudo apt-get install golang
      sudo apt-get install exuberant-ctags
      sudo apt-get install libclang-dev
    elif [[ "$platform" == "Darwin" ]]; then
      brew install git
      brew install git-extras
      brew install git-flow
      brew install wget
      brew install ack
      brew install node
      brew install go
      brew install ffmpeg
      brew install macvim
      brew install tmux
      brew install ctags
      brew install jpeg-turbo
      brew link jpeg-turbo
      brew install optipng
      # tmux pasteboard fixes issue of using macvim from tmux
      brew install reattach-to-user-namespace
    fi
    # install Go utilities
    go get -u github.com/nsf/gocode
  fi

  # install pythonz for python managment
  read "pythonz?Install pythonz for python managment? [yN] "
  if [[ "$pythonz" =~ ^[Yy]$ ]]; then
    curl -kL https://raw.github.com/saghul/pythonz/master/pythonz-install | bash
  fi

  # install spf13-vim3 vim files
  if [[ ! -d $HOME/.spf13-vim-3 ]]; then
    read "vim?Install vim bundles? [yN] "
    if [[ "$vim" =~ ^[Yy]$ ]]; then
      curl http://j.mp/spf13-vim3 -L -o - | sh
    fi
  fi

fi
