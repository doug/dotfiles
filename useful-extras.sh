function tabs2spaces {
  for file in `find . -name "$1"`; do expand -t 2 $file > $file.new; mv $file.new $file; done
}

function spaces2tabs {
  for file in `find . -name "$1"`; do unexpand -t 2 $file > $file.new; mv $file.new $file; done
}

function markdown2pdf {
  markdown $1 | htmldoc --cont --headfootsize 8.0 --linkcolor blue --linkstyle plain --format pdf14 - > $2
}

function license-apache {
  curl http://www.apache.org/licenses/LICENSE-2.0.txt > LICENSE
}

function convert2webm {
  ffmpeg -i $1 -acodec libvorbis -ac 2 -ab 96k -ar 44100 -b 345k -s 640x360 $2
}

function convert2ogv {
  ffmpeg -i $1 -acodec libvorbis -ac 2 -ab 96k -ar 44100 -b 345k -s 640x360 $2
}

function convert2mp4 {
  ffmpeg -i $1 -acodec libfaac -ab 96k -vcodec libx264 -vpre slower -vpre main -level 21 -refs 2 -b 345k -bt 345k -threads 0 -s 640x360 $2
}


