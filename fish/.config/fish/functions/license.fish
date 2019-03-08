function license --description "Download an OSS license."
  switch $argv
    case apache apache-2.0 Apache
      set year (date '+%Y')
      read -p "echo 'Name of the copywrite holder? '" name
      curl https://raw.githubusercontent.com/github/choosealicense.com/gh-pages/_licenses/apache-2.0.txt \
        | sed -e "s/{yyyy}/$year/g" -e "s/{name of copyright owner}/$name/g" \
        > LICENSE
    case mit MIT
      set year (date '+%Y')
      read -p "echo 'Name of the copywrite holder? '" name
      curl https://raw.githubusercontent.com/github/choosealicense.com/gh-pages/_licenses/mit.txt \
        | sed "/---/,/---/d" \
        | sed -n "2,100000p" \
        | sed -e "s/\[year\]/$year/g" -e "s/\[fullname\]/$name/g" \
        > LICENSE
    case *
      echo "License $argv not found."
  end
end
