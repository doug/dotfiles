function boil --description "Get and expand a gist useful for templating"
  curl -O -L $argv/archive/master.zip
  unzip master.zip
  rm master.zip
  set directory (basename $argv)-master
  mv $directory/* .
  rmdir $directory
end
