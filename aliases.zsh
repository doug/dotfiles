if [[ "$PLATFORM"  == "Darwin" ]]; then
  alias gvim=mvim
  alias python32="arch -i386 python"
  alias signalstrength="while x=1; do /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep CtlRSSI | sed -e 's/^.*://g' | xargs -I SIGNAL printf \"\rRSSI dBm: SIGNAL\"; sleep 0.5; done"
  alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
elif [[ "$PLATFORM" == "Linux" ]]; then
  # Linux Aliases
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"
  alias open="xdg-open"
  alias trash="gvfs-trash"
fi

function pythonlib {
  python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"
}

function google {
  open "https://www.google.com/#q=$1"
}

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

function git-create {
  server=${1%%[/]*}
  remote=${1#*[/]}
  ssh $server "mkdir -p /$remote && cd /$remote && git init --bare"
}

function chop_wav() {
  wav=$1
  step=$2
  duration=$(soxi -D $wav)
  echo $duration
  steps=$((duration/step))
  echo $steps
  for x in $(seq 0 $steps); do
    echo $x
    sox $wav $x.wav trim $((x*step)) $step
  done
}

function chop_mp3() {
  file=$1
  step=$2
  wav=full.wav
  lame --decode $1 $wav
  duration=$(soxi -D $wav)
  echo $duration
  steps=$((duration/step))
  echo $steps
  for x in $(seq 0 $steps); do
    echo $x
    sox $wav out.wav trim $((x*step)) $step
    #ffmpeg -i out.wav $x.m4a
    lame out.wav $x.mp3
    rm -f out.wav
  done
  rm -f $wav
}

# get and expand a gist useful for templating
function getgist() {
  curl -0 $1/download | tar -xz
  set -- gist*
  mv $1/* .
  rmdir $1
}

# force 256 color support in tmux
alias tmux="tmux -2"

# git aliases
alias update-submodules="git submodule foreach \"(git checkout master; git pull)&\""
alias s="nocorrect git status"
#alias t="todo.sh"
#alias tt="todo.sh ls"

alias noise="play -c 2 -n synth pinknoise band -n 2500 4000 reverb 20"
alias gamma="play -n synth sin 315 sin 365 remix 1 2"
alias beta="play -n synth sin 315 sin 340 remix 1 2"
alias alpha="play -n synth sin 315 sin 325 remix 1 2"
alias theta="play -n synth sin 315 sin 320 remix 1 2"
alias delta="play -n synth sin 315 sin 317 remix 1 2"
alias gammap="play -n synth sin 315 sin 365 pinknoise remix 1,3 2,3"
alias ocean="play -c 2 -r 41k -t sl - synth $len brownnoise tremolo .13 70 < /dev/zero"
alias brown="play -c 2 -n synth 60:00 brownnoise"
#play -n synth 2 sin 440-880 fade h 2 gain -5 : synth 2 sin 880-660 gain -5
#play -r 32000 -t sl - synth $len pinknoise band -n 600 400 tremolo 20 .1 < /dev/zero
#play -c 2 -n synth pinknoise band -n 2500 4000 reverb 20
#play -m "|sox -n -p synth sin " "|sox -n -p synth 2 tremolo 10" "|sox -n -p synth pinknoise band -n 2500 4000 reverb 20"


