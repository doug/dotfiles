#!/usr/bin/env zsh

#Be sure to change your shell first
#chsh -s `which zsh`

# ZSH=`which zsh`
# if [[ "$SHELL" != "$ZSH" ]]; then
#   echo "Switching shell to zsh."
#   chsh -s $ZSH
#   echo "Please restart your terminal session."
#   exit
# fi

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

  if [[ ! -d $HOME/bin/nacl-sdk ]]; then
    read "naclsdk?Install NaCl SDK? [yN] "
    curl http://storage.googleapis.com/nativeclient-mirror/nacl/nacl_sdk/nacl_sdk.zip > nacl_sdk.zip
    unzip nacl_sdk.zip
    rm -f nacl_sdk.zip
    mv nacl_sdk $HOME/bin/nacl-sdk
  fi

  if [[ ! -d $HOME/bin/android-sdk ]]; then
    read "androidsdk?Install Android SDK? [yN] "
    if [[ "$androidsdk" =~ ^[Yy]$ ]]; then
      # SDK
      mkdir -p $HOME/bin
      OS="linux-x86_64"
      VERSION="20131030"
      if [[ "$platform" == "Darwin" ]]; then
        OS="mac-x86_64"
      fi
      curl http://dl.google.com/android/adt/adt-bundle-$OS-$VERSION.zip > adt.zip
      unzip adt.zip
      mv adt-bundle-$OS-$VERSION $HOME/bin/android-sdk
      rm -f adt.zip
      # NDK
      if [[ "$platform" == "Darwin" ]]; then
        OS="darwin-x86_64"
      fi
      curl http://dl.google.com/android/ndk/android-ndk-r9c-$OS.tar.bz2 > ndk.tar.bz2
      tar xvf ndk.tar.bz2
      rm -f ndk.tar.bz2
      mv android-ndk-r9c $HOME/bin/android-ndk
    fi
  fi

  if [[ ! -d $HOME/bin/google-cloud-sdk ]]; then
    read "cloudsdk?Install Google Cloud SDK? [yN] "
    if [[ "$cloudsdk" =~ ^[Yy]$ ]]; then
      mkdir -p $HOME/bin
      APPENGINE_SDK=$HOME/bin/google-cloud-sdk
      curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk-python.zip > cloud.zip
      unzip cloud.zip
      mv google-cloud-sdk $APPENGINE_SDK
      rm -f cloud.zip
      sh $APPENGINE_SDK/INSTALL
      #$APPENGINE_SDK/bin/gcloud components update pkg-python
      $APPENGINE_SDK/bin/gcloud components update pkg-java
      $APPENGINE_SDK/bin/gcloud components update pkg-go-x86_64
      mkdir -p $HOME/.gogae
      ln -s $APPENGINE_SDK/platform/google_appengine_go_amd64/goroot/src/pkg $HOME/.gogae/src
    fi
  fi

  if [[ ! -d $HOME/bin/dart ]]; then
    read "dartsdk?Install Dart SDK? [yN] "
    if [[ "$dartsdk" =~ ^[Yy]$ ]]; then
      mkdir -p $HOME/bin
      if [[ $platform == "Darwin" ]]; then
        PLATFORMSTR="macos-x64"
      else
        PLATFORMSTR="linux-x64"
      fi
      curl http://storage.googleapis.com/dart-archive/channels/stable/release/latest/editor/darteditor-${PLATFORMSTR}.zip > darteditor.zip
      unzip darteditor.zip
      rm -f darteditor.zip
      mv dart $HOME/bin
      ln -s dart/dart-sdk $HOME/bin/dart-sdk
    fi
  fi

  if [[ ! -d $HOME/.nvm ]]; then
    read "nvm?Install nvm? [yN] "
    if [[ "$nvm" =~ ^[Yy]$ ]]; then
      git clone git://github.com/creationix/nvm.git $HOME/.nvm
    fi
  fi
  if [[ ! -f $HOME/bin/lein ]]; then
    read "lein?Install lein (clojure's leiningen)? [yN] "
    if [[ "$lein" =~ ^[Yy]$ ]]; then
      mkdir -p $HOME/bin
      curl https://raw.github.com/technomancy/leiningen/stable/bin/lein > $HOME/bin/lein
      chmod a+x $HOME/bin/lein
    fi
  fi

  if [[ ! -f $HOME/bin/git-fat ]]; then
    read "fat?Install git-fat? [yN] "
    if [[ "$fat" =~ ^[Yy]$ ]]; then
      mkdir -p $HOME/bin
      curl https://raw.github.com/jedbrown/git-fat/master/git-fat > $HOME/bin/git-fat
      chmod a+x $HOME/bin/git-fat
    fi
  fi

  read "base?Install base packages? [yN] "
  if [[ "$base" =~ ^[Yy]$ ]]; then
    if [[ "$platform" == "Linux" ]]; then
      sudo apt-get -y install git
      sudo apt-get -y install build-essential
      sudo apt-get -y install exuberant-ctags
      sudo apt-get -y install libclang-dev
      sudo apt-get -y install ack
      sudo apt-get -y install tmux
      sudo apt-get -y install vim
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
  #if [[ ! -d $HOME/.spf13-vim-3 ]]; then
    #read "vim?Install vim bundles? [yN] "
    #if [[ "$vim" =~ ^[Yy]$ ]]; then
      #sh <(curl https://j.mp/spf13-vim3 -L)
    #fi
  #fi

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

  source $HOME/.zshenv
  source $HOME/.zshrc

fi
