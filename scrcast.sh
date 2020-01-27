#!/bin/sh

[ -z "$1" ] && {
  cat <<EOF
usage: $0 </path/to/output/file>
EOF
  exit 1
}

# -an disable audio recording

#ffmpeg -f x11grab -s 1600x900 -hwaccel auto -i :0.0 -f pulse -ac 1 -i default -c:v libvpx -b:v 5M -crf 10 -quality realtime "$1"

ffmpeg \
    -video_size 1600x900 \
    -framerate 30 -f x11grab -i :0.0 \
    -probesize 42M \
    -f pulse -ac 1 -i default \
    "$1"

