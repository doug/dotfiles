platform=`uname`

if [[ "$platform" == "Linux" || "$platform" == "Darwin" ]]; then

  chsh -s `which zsh`

  if [[ "$platform" == "Linux" ]]; then
    echo "Setting up Linux"
    sudo apt-get install gfortran
  elif [[ "$platform" == "Darwin" ]]; then
    echo "Setting up Mac"
    curl http://spectacleapp.com/updates/downloads/Spectacle%200.7.zip > spectacle.zip
    unzip spectacle.zip
    mv Spectacle.app /Applications
    rm spectacle.zip
    mkdir $HOME/.homebrew && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
  fi

  # Download fonts I like
  mkdir -p fonts
  ./gfont.py "http://googlefontdirectory.googlecode.com/hg/ofl/dosis/METADATA.json"
  ./gfont.py "http://googlefontdirectory.googlecode.com/hg/ofl/anonymouspro/METADATA.json"
  ./gfont.py "http://googlefontdirectory.googlecode.com/hg/ofl/inconsolata/METADATA.json"
  ./gfont.py "http://googlefontdirectory.googlecode.com/hg/ofl/sourcecodepro/METADATA.json"

  # Install rvm
  curl -L https://get.rvm.io | bash -s stable --ruby

  # Install pythonbrew
  curl -kL http://xrl.us/pythonbrewinstall | bash

  source $HOME/.rvm/scripts/rvm
  source $HOME/.pythonbrew/etc/bashrc
  # copy and install these dotfiles
  rake install

  if [[ "$platform" == "Linux" ]]; then
    git config --global credential.helper cached
    pythonbrew install 2.7.3
  elif [[ "$platform" == "Darwin" ]]; then
    git config --global credential.helper osxkeychain
    pythonbrew install --framework --configure="--with-universal-archs=intel --enable-universalsdk" 2.7.3
  fi
  pythonbrew switch 2.7.3
  easy_install readline
  pip install ipython
  pip install pil
  pip install requests
  pip install numpy
  pip install scipy


  if [[ "$platform" == "Linux" ]]; then
    sudo apt-get install ffmpeg
    sudo apt-get install exuberant-ctags
    sudo apt-get install libclang-dev
  elif [[ "$platform" == "Darwin" ]]; then
    brew install git
    brew install wget
    brew install node
    brew install go
    brew install ffmpeg
    brew install gfortran
    brew install macvim
    brew install tmux
    brew install ctags
    # tmux pasteboard fixes issue of using macvim from tmux
    brew install reattach-to-user-namespace
  fi

fi
