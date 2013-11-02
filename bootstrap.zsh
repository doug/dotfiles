#!/usr/bin/env zsh

#Be sure to change your shell first
#chsh -s `which zsh`

ZSH=`which zsh`
if [[ "$SHELL" != "$ZSH" ]]; then
  echo "Switching shell to zsh."
  chsh -s $ZSH
  echo "Please restart your terminal session."
  exit
fi

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
      read "spectacle?Install Spectacle for window management? [yN] "
      if [[ "$spectacle" =~ ^[Yy]$ ]]; then
        curl https://s3.amazonaws.com/spectacle/downloads/Spectacle+0.8.2.zip > spectacle.zip
        unzip spectacle.zip
        mv Spectacle.app /Applications
        rm spectacle.zip
      fi
    fi
    if [[ ! -d $HOME/.homebrew ]]; then
      mkdir $HOME/.homebrew && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
      export PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH
    fi
    # echo $HOME/.homebrew/bin > /etc/paths.d/homebrew
  fi

  # install prezto
  if [[ ! -d $HOME/.zprezto ]]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"
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
    if [[ "$platform" == "Linux" ]]; then
      git config --global credential.helper cache
    elif [[ "$platform" == "Darwin" ]]; then
      git config --global credential.helper osxkeychain
    fi
  fi

  if [[ ! -d $HOME/bin/google-cloud-sdk ]]; then
    read "cloudsdk?Install Google Cloud SDK? [yN] "
    if [[ "$cloudsdk" =~ ^[Yy]$ ]]; then
      curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk-python.zip > cloud.zip
      unzip cloud.zip
      mv google-cloud-sdk $HOME/bin/google-cloud-sdk
      rm -f cloud.zip
      sh $HOME/bin/google-cloud-sdk/INSTALL
      echo "use 'gcloud components list' to list components."
      echo "to install java for example 'gcloud components update pkg-java'"
    fi
  fi

  if [[ ! -d $HOME/bin/dart-sdk ]]; then
    read "dartsdk?Install Dart SDK? [yN] "
    if [[ "$dartsdk" =~ ^[Yy]$ ]]; then
      mkdir -p $HOME/bin
      if [[ $platform == "Darwin" ]]; then
        PLATFORMSTR="macos-64"
      else
        PLATFORMSTR="linux-64"
      fi
      curl https://storage.googleapis.com/dart-editor-archive-integration/latest/dartsdk-${PLATFORMSTR}.tar.gz > dartsdk.tar.gz
      tar xvfz dartsdk.tar.gz
      rm -f dartsdk.tar.gz
      mv dart-sdk $HOME/bin
    fi
  fi

  if [[ ! -d $HOME/.nvm ]]; then
    read "nvm?Install nvm? [yN] "
    if [[ "$nvm" =~ ^[Yy]$ ]]; then
      git clone git://github.com/creationix/nvm.git $HOME/.nvm
    fi
  fi

  read "base?Install base packages? [yN] "
  if [[ "$base" =~ ^[Yy]$ ]]; then
    if [[ "$platform" == "Linux" ]]; then
      sudo apt-get install git
      sudo apt-get install build-essential
      sudo apt-get install exuberant-ctags
      sudo apt-get install libclang-dev
      sudo apt-get install ack
      sudo apt-get install tmux
      sudo apt-get install vim
    elif [[ "$platform" == "Darwin" ]]; then
      brew install git
      brew install git-extras
      brew install wget
      brew install ack
      brew install tmux
      brew install ctags
      # tmux pasteboard fixes issue of copy/paste from tmux
      brew install reattach-to-user-namespace
      brew install zsh
    fi
  fi

  # install pyenv for python managment
  if [[ ! -d $HOME/.pyenv ]]; then
    read "pyenv?Install pyenv for python management? [yN] "
    if [[ "$pyenv" =~ ^[Yy]$ ]]; then
      git clone git://github.com/yyuu/pyenv.git $HOME/.pyenv
    fi
  fi

  # install spf13-vim3 vim files
  if [[ ! -d $HOME/.spf13-vim-3 ]]; then
    read "vim?Install vim bundles? [yN] "
    if [[ "$vim" =~ ^[Yy]$ ]]; then
      sh <(curl https://j.mp/spf13-vim3 -L)
    fi
  fi

  if [[ ! -d $HOME/.rvm ]]; then
    read "rvm?Install rvm? [yN] "
    if [[ "$rvm" =~ ^[Yy]$ ]]; then
      curl -L https://get.rvm.io | bash -s stable --autolibs=enabled --ruby=1.9.3
    fi
  fi

  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^(README.md|zshrc|zpreztorc)(.); do
    ln -fns "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    echo "Linking $rcfile to ${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done

  for rcfile in "${current}"/^(bootstrap.sh|*.template|osx|tmux.osx.conf|themes|config); do
    ln -fns "$rcfile" "$HOME/.${rcfile:t}"
    echo "Linking $rcfile to $HOME/.${rcfile:t}"
  done

  mkdir -p $HOME/.config

  for configfile in "${current}"/config/*; do
    ln -fns "$configfile" "$HOME/.config/${configfile:t}"
    echo "Linking $configfile to $HOME/.config/${configfile:t}"
  done

  if [[ "$platform" == "Darwin" ]]; then
    mv $HOME/.tmux.conf $HOME/.tmux.base.conf
    ln -fns $current/tmux.osx.conf $HOME/.tmux.conf
  fi

  exec $SHELL

fi
