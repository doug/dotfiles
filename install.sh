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
    binfiles=(rcode)
    for binfile in "${binfiles[@]}"; do
      echo "Linking $binfile to $HOME/bin/$binfile"
      ln -fns "$current/$binfile" "$HOME/bin/$binfile"
      chmod +x "$HOME/bin/$binfile"
    done
  fi

  if [[ ! -d $HOME/.bash_it ]]; then
    echo "Install bash-it framework? [yN] "
    read bashit
    if [[ "$bashit" =~ ^[Yy]$ ]]; then
      git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
    fi
  fi

  if [[ -d $HOME/.bash_it ]]; then
    echo "Set default bash-it plugins? [yN] "
    read bashitplugins
    if [[ "$bashitplugins" =~ ^[Yy]$ ]]; then
      source $HOME/.bashrc
      bash-it disable plugin all
      bash-it disable alias all
      bash-it disable completion all
      bash-it enable plugin base alias-completion extract git history tmux todo
      bash-it enable alias ag atom docker general git npm tmux todo vim
      bash-it enable completion bash-it docker git git_flow gulp npm pip ssh system tmux todo
      if [[ "$platform" == "Linux" ]]; then
        bash-it enable alias apt clipboard
        bash-it enable completion brew
      elif [[ "$platform" == "Darwin" ]]; then
        bash-it enable plugin osx-timemachine osx
        bash-it enable alias homebrew-cask homebrew osx
      fi
    fi
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

    echo "Install default Apps? (Atom, Chrome, Spectacle, ... ) [yN] "
    read apps
    if [[ "$apps" =~ ^[Yy]$ ]]; then
      if command -v brew-cask >/dev/null 2>&1; then
        brew cask install google-chrome
        brew cask install atom
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
    # Powerline fonts
    git clone https://github.com/powerline/fonts.git --depth=1 .powerlinefonts
    # install
    cd .powerlinefonts
    ./install.sh
    # cleanup
    cd ..
    rm -rf .powerlinefonts
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

  if [[ ! -d $HOME/bin/dart ]]; then
    echo "Install Dart SDK? [yN] "
    read dartsdk
    if [[ "$dartsdk" =~ ^[Yy]$ ]]; then
      mkdir -p $HOME/bin
      if [[ $platform == "Darwin" ]]; then
        PLATFORMSTR="macos-x64"
      else
        PLATFORMSTR="linux-x64"
      fi
      curl -L http://storage.googleapis.com/dart-archive/channels/stable/release/latest/editor/darteditor-${PLATFORMSTR}.zip > darteditor.zip
      unzip darteditor.zip
      rm -f darteditor.zip
      mv dart $HOME/bin
      echo "Dart sdk not added to path by default add $HOME/bin/dart/dart-sdk/bin"
    fi
  fi


  if [[ ! -d $HOME/bin/android-sdk ]]; then
    echo "Install Android SDK? [yN] "
    read androidsdk
    if [[ "$androidsdk" =~ ^[Yy]$ ]]; then
      # SDK
      mkdir -p $HOME/bin
      VERSION="r24.4"
      if [[ "$platform" == "Darwin" ]]; then
        OS="macosx"
        curl -L http://dl.google.com/android/android-sdk_$VERSION-$OS.zip > android.zip
        unzip android.zip
        mv android-sdk-$OS $HOME/bin/android-sdk
        rm android.zip
      else
        OS="linux"
        curl -L http://dl.google.com/android/android-sdk_$VERSION-$OS.tgz > android.tgz
        tar xvfz android.tgz
        mv android-sdk-$OS $HOME/bin/android-sdk
        rm android.tgz
      fi
      # NDK
      OS="linux-x86_64"
      if [[ "$platform" == "Darwin" ]]; then
        OS="darwin-x86_64"
      fi
      VERSION="r10e"
      curl -L http://dl.google.com/android/ndk/android-ndk-$VERSION-$OS.bin > ndk.bin
      chmod a+x ndk.bin
      ./ndk.bin
      rm ndk.bin
      mv android-ndk-$VERSION $HOME/bin/android-ndk
    fi
  fi

  if [[ ! -d $HOME/bin/google-cloud-sdk ]]; then
    echo "Install Google Cloud SDK? [yN] "
    read cloudsdk
    if [[ "$cloudsdk" =~ ^[Yy]$ ]]; then
      mkdir -p $HOME/bin
      APPENGINE_SDK=$HOME/bin/google-cloud-sdk
      curl -L https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip > cloud.zip
      unzip cloud.zip
      mv google-cloud-sdk $APPENGINE_SDK
      rm -f cloud.zip
      sh $APPENGINE_SDK/install.sh
    fi
  fi

  if [[ ! -d $HOME/.nvm ]]; then
    echo "Install nvm? [yN] "
    read nvm
    if [[ "$nvm" =~ ^[Yy]$ ]]; then
      git clone git://github.com/creationix/nvm.git $HOME/.nvm
      sh $HOME/.nvm/install.sh
    fi
  fi

  echo "Install base packages? [yN] "
  read base
  if [[ "$base" =~ ^[Yy]$ ]]; then
    if [[ "$platform" == "Linux" ]]; then
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
    elif [[ "$platform" == "Darwin" ]]; then
      if ! command -v brew >/dev/null 2>&1; then
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

  if command -v apm >/dev/null 2>&1; then
    echo "Install atom packages and themes? [yN] "
    read apm
    if [[ "$apm" =~ ^[Yy]$ ]]; then
      mkdir -p $HOME/bin
      curl -o $HOME/bin/ratom https://raw.githubusercontent.com/aurora/rmate/master/rmate
      chmod +x $HOME/bin/ratom
      apm install atom-material-syntax
      apm install atom-material-syntax-light
      apm install atom-material-ui
      apm install atom-typescript
      apm install autocomplete-glsl
      apm install autocomplete-python
      apm install autoprefixer
      apm install color-picker
      apm install clang-format
      apm install docblockr
      apm install editorconfig
      apm install file-icons
      apm install git-time-machine
      apm install git-plus
      apm install go-plus
      apm install go-debug
      apm install graphviz-preview-plus
      apm install language-babel
      apm install language-docker
      apm install language-fish-shell
      apm install language-glsl
      apm install language-lua
      apm install language-protobuf
      apm install language-viml
      apm install linter
      apm install linter-jscs
      apm install linter-lua
      apm install markdown-toc
      apm install markdown-writer
      apm install merge-conflicts
      apm install minimap
      apm install pigments
      apm install pdf-view
      apm install pretty-json
      apm install todo-show
      apm install vim-mode
      apm install xml-formatter

      apm disable link
      apm disable language-mustache
      apm disable language-ruby-on-rails
      apm disable metrics
      apm disable welcome
    fi
  fi

  echo "All finished, please reload your terminal."

fi
