platform=`uname`

if [[ "$platform" == "Linux" || "$platform" == "Darwin" ]]; then

chsh -s `which zsh`

if [[ "$platform" == "Linux" ]]; then

echo "Setting up Linux"

elif [[ "$platform" == "Darwin" ]]; then

echo "Setting up Mac"
curl -fsS https://raw.github.com/mxcl/homebrew/go | bash --ruby

fi

# download fonts I like
#mkdir -p fonts
#curl http://googlefontdirectory.googlecode.com/hg/ofl/anonymouspro/AnonymousPro-Bold.ttf > fonts/AnonymousPro-Bold.ttf
#curl http://googlefontdirectory.googlecode.com/hg/ofl/anonymouspro/AnonymousPro-Regular.ttf > fonts/AnonymousPro-Regular.ttf
#curl http://googlefontdirectory.googlecode.com/hg/ofl/anonymouspro/AnonymousPro-Italic.ttf > fonts/AnonymousPro-Italic.ttf
#curl http://googlefontdirectory.googlecode.com/hg/ofl/anonymouspro/AnonymousPro-BoldItalic.ttf > fonts/AnonymousPro-BoldItalic.ttf

# Install rvm
curl -L https://get.rvm.io | bash -s stable --ruby

# Install pythonbrew
curl -kL http://xrl.us/pythonbrewinstall | bash

source $HOME/.rvm/scripts/rvm
source $HOME/.pythonbrew/etc/bashrc
rake install

pythonbrew install 2.7.3
pythonbrew switch 2.7.3
pip install readline
pip install ipython
pip install requests

# Download fonts
mkdir -p fonts
./gfont.py "http://googlefontdirectory.googlecode.com/hg/ofl/dosis/METADATA.json"
./gfont.py "http://googlefontdirectory.googlecode.com/hg/ofl/anonymouspro/METADATA.json"

fi
