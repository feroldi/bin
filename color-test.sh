#!/bin/sh

range.sh 0 255 | while read I; do
    printf "\x1b[48;5;%sm%3d\e[0m " "$I" "$I"
    [ $I -eq 15 ] || \
    [ $I -gt 15 ] && \
    [ $(( (I-15) % 16 )) -eq 0 ] && \
    {
        printf "\n"
    }
done

