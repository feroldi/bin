#!/usr/bin/env sh

# -an disable audio recording

ffmpeg -f x11grab -s 1600x900 \
    -i :0.0 -f pulse -i default -an -c:v libvpx -b:v 5M -crf 10 \
    -quality realtime "$1.webm"

