#!/bin/sh

STREAM=${1:-http://localhost:8090/0.ffm}

ffmpeg -f x11grab -r 5 -s 1366x768 -thread_queue_size 1024 -i :0.0 \
       -f alsa -ac 1 -thread_queue_size 1024 -i default \
       -af 'highpass=f=200, lowpass=f=2000' \
       -fflags nobuffer ${STREAM} \
       -af 'highpass=f=200, lowpass=f=2000' \
       -c:v libvpx -b:v 5M -c:a libvorbis \
        media/webcast/wc-$(date +%Y%m%d%H%M%S).webm

