Doug's Dot Files
===============

    git clone git@github.com:doug/dotfiles.git --recursive ~/.dotfiles
    cd ~/.dotfiles
    rake install

This is for people who use vim, zsh, and tmux.

I also recommend checking out [solarized](http://ethanschoonover.com/solarized) for your terminal
colors.

You should also install [homebrew](https://github.com/mxcl/homebrew) if on OSX, this zshrc makes bad
bad assumptions about your homebrew install and will probably need to be modded to work properly,
until I fix it to make it more general. Also, I use [Chris Johnsen's tmux
pasteboard](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard) to get tmux to play nice with
pbcopy and pbpaste, I recommend installing that as well if you are using tmux.

ZSH files provided by [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
VIMFILES are my collection of other peoples gitrepos as submodules with my own and others twists
The rake file was modded from [ryanb's dotfiles](https://github.com/ryanb/dotfiles)
