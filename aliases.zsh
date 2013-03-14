if [[ "$PLATFORM"  == "Darwin" ]]; then
  alias gvim=mvim
  alias python32="arch -i386 python"
  alias signalstrength="while x=1; do /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep CtlRSSI | sed -e 's/^.*://g' | xargs -I SIGNAL printf \"\rRSSI dBm: SIGNAL\"; sleep 0.5; done"
  alias pyengine="brew unlink go-app-engine-64 && brew link google-app-engine"
  alias goengine="brew unlink google-app-engine && brew link go-app-engine-64"
  alias subl="/Applications/Sublime\ Text\ 2.app/Contents/MacOS/Sublime\ Text\ 2 -w"
elif [[ "$PLATFORM" == "Linux" ]]; then
  # Linux Aliases
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"
  alias open="xdg-open"
fi

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

# git aliases
alias update-submodules="git submodule foreach \"(git checkout master; git pull)&\""
alias s="nocorrect git status"
#alias t="todo.sh"
#alias tt="todo.sh ls"

alias noise="play -c 2 -n synth pinknoise band -n 2500 4000 reverb 20"
alias gamma="play -c 2 -n synth pinknoise band -n 315 365 reverb 20"
alias beta="play -c 2 -n synth pinknoise band -n 315 340 reverb 20"
alias alpha="play -c 2 -n synth pinknoise band -n 315 325 reverb 20"
alias theta="play -c 2 -n synth pinknoise band -n 315 320 reverb 20"
alias delta="play -c 2 -n synth pinknoise band -n 315 317 reverb 20"
alias ocean="play -c 2 -r 41k -t sl - synth $len brownnoise tremolo .13 70 < /dev/zero"
alias brown="play -c 2 -n synth 60:00 brownnoise"
#play -n synth 2 sin 440-880 fade h 2 gain -5 : synth 2 sin 880-660 gain -5
#play -r 32000 -t sl - synth $len pinknoise band -n 600 400 tremolo 20 .1 < /dev/zero
#play -c 2 -n synth pinknoise band -n 2500 4000 reverb 20
#play -m "|sox -n -p synth sin " "|sox -n -p synth 2 tremolo 10" "|sox -n -p synth pinknoise band -n 2500 4000 reverb 20"

