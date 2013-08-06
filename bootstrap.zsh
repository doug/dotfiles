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
      curl https://s3.amazonaws.com/spectacle/downloads/Spectacle+0.8.2.zip > spectacle.zip
      unzip spectacle.zip
      mv Spectacle.app /Applications
      rm spectacle.zip
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

  if [[ ! -d $HOME/bin/cloudsdk ]]; then
    read "cloudsdk?Install Google Cloud SDK? [yN] "
    if [[ "$cloudsdk" =~ ^[Yy]$ ]]; then
      mkdir -p $HOME/bin/cloudsdk
      CLOUD_VERSION="0.9.6"
      if [[ $platform == "Darwin" ]]; then
        PLATFORMSTR="mac"
      else
        PLATFORMSTR="linux"
      fi
      curl https://dl.google.com/dl/cloudsdk/google-cloud-sdk-${CLOUD_VERSION}-${PLATFORMSTR}-python.zip > cloud.zip
      unzip cloud.zip
      mv google-cloud-sdk-${CLOUD_VERSION} $HOME/bin/cloudsdk/python
      rm -f cloud.zip
      curl https://dl.google.com/dl/cloudsdk/google-cloud-sdk-${CLOUD_VERSION}-${PLATFORMSTR}-go_amd64.zip > cloud.zip
      unzip cloud.zip
      mv google-cloud-sdk-${CLOUD_VERSION} $HOME/bin/cloudsdk/go
      rm -f cloud.zip
      ln -s cloudsdk/python $HOME/bin/cloudsdk-current
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
      sudo apt-get install fasd
    elif [[ "$platform" == "Darwin" ]]; then
      brew install git
      brew install git-extras
      brew install wget
      brew install ack
      brew install go
      brew install tmux
      brew install ctags
      brew install jpeg-turbo
      brew link jpeg-turbo
      brew install optipng
      # tmux pasteboard fixes issue of using macvim from tmux
      brew install reattach-to-user-namespace
      brew install zsh
    fi
    # install Go utilities
    #go get -u github.com/nsf/gocode
  fi

  # install pythonbrew for python managment
  read "pythonbrew?Install pythonbrew for python management? [yN] "
  if [[ "$pythonbrew" =~ ^[Yy]$ ]]; then
    curl -kL http://xrl.us/pythonbrewinstall | bash
  fi


  # install spf13-vim3 vim files
  if [[ ! -d $HOME/.spf13-vim-3 ]]; then
    read "vim?Install vim bundles? [yN] "
    if [[ "$vim" =~ ^[Yy]$ ]]; then
      curl http://j.mp/spf13-vim3 -L -o - | sh
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

  for rcfile in "${current}"/^(bootstrap.sh|*.template|osx|tmux.osx.conf|themes)*; do
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

  source $HOME/.zshrc

fi
