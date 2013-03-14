#!/usr/bin/env zsh

#Be sure to change your shell first
#chsh -s `which zsh`

platform=`uname`

if [[ "$platform" == "Linux" || "$platform" == "Darwin" ]]; then

    if [[ "$platform" == "Linux" ]]; then
        echo "Setting up Linux"
        sudo apt-get install gfortran
    elif [[ "$platform" == "Darwin" ]]; then
        echo "Setting up Mac"
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

    # install spf13-vim3 vim files
    if [[ ! -d $HOME/.spf13-vim-3 ]]; then
        curl http://j.mp/spf13-vim3 -L -o - | sh
    fi

    # install prezto
    if [[ ! -d $HOME/.zprezto ]]; then
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    fi

    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^(README.md|zshrc|zpreztorc)(.N); do
        ln -fns "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        echo "Linking $rcfile to ${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done

    current=$(dirname "$0:A" )
    for rcfile in "${current}"/^(bootstrap.sh|*.template)(.N); do
        ln -fns "$rcfile" "$HOME/.${rcfile:t}"
        echo "Linking $rcfile to $HOME/.${rcfile:t}"
    done
    
    for rcfile in "${current}"/(*.template)(.N); do
        cp "$rcfile" "$HOME/.${rcfile:t:s/.template//}"
        echo "Copying template $rcfile to $HOME/.${rcfile:t:s/.template//}"
    done

    if [[ "$platform" == "Linux" ]]; then
        git config --global credential.helper cached
    elif [[ "$platform" == "Darwin" ]]; then
        git config --global credential.helper osxkeychain
    fi

    read "update?Personalize gitconfig? [yN] "
    if [[ "$update" =~ ^[Yy]$ ]]; then
        read "name?Your name: "
        git config --global user.name $name
        read "email?Your email: "
        git config --global user.email $email
        read "github?Github username: "
        git config --global github.user $github
    fi
    
    read "update?Install base packages? [yN] "
    if [[ "$update" =~ ^[Yy]$ ]]; then
        if [[ "$platform" == "Linux" ]]; then
            sudo apt-get install git
            sudo apt-get install build-essential
            sudo apt-get install ffmpeg
            sudo apt-get install node
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
    fi

fi
