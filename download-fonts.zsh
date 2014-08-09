mkdir -p $HOME/.fonts
for x in Roboto Anonymous-Pro source-sans-pro open-sans Raleway quicksand dosis source-code-pro code Museo League-Gothic; do 
  curl -O http://www.fontsquirrel.com/fonts/download/$x
  unzip -o $x -d $HOME/.fonts
  rm $x
done

if [[ "$OSTYPE" == linux* ]]; then
  fc-cache -fv
fi
