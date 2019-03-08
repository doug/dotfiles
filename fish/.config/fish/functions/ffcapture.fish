function ffcapture
  switch (uname)
    case Linux
      xwininfo | pipeset dim
      set w (echo $dim | awk '/Width/ {print $2}')
      set h (echo $dim | awk '/Height/ {print $2}')
      # keep divisible by 2
      if math "$w % 2" > /dev/null
        set w (math "$w + 1")
      end
      if math "$h % 2" > /dev/null
        set h (math "$h + 1")
      end
      set x (echo $dim | awk '/Absolute upper-left X/ {print $4}')
      set y (echo $dim | awk '/Absolute upper-left Y/ {print $4}')
      set cmd -video_size (echo $w)x(echo $h) -framerate 24 -f x11grab -i :0.0+(echo $x),(echo $y) $argv
      echo $cmd
      if type avconv > /dev/null
        avconv $cmd
      else if type ffmepg > /dev/null
        ffmpeg $cmd
      else
        echo 'Must have ffmpeg or libav-tools installed.'
      end
    case *
      echo 'Only linux is supported.'
    end
end
