if [[ "$OSTYPE" == linux* ]]; then
  FONTDIR=$HOME/.fonts
elif
  [[ "$OSTYPE" == darwin* ]]; then
  FONTDIR=$HOME/Library/Fonts
fi

if ! hash unzip 2>/dev/null; then
  echo "Must have unzip installed."
  exit
fi

mkdir -p $FONTDIR
for x in Roboto Roboto-Slab Roboto-Condensed Anonymous-Pro source-sans-pro open-sans Raleway quicksand dosis source-code-pro code Museo League-Gothic; do
  curl -L -O http://www.fontsquirrel.com/fonts/download/$x
  unzip -o $x -d $FONTDIR
  rm $x
done

if [[ "$OSTYPE" == linux* ]]; then
  fc-cache -fv
fi
