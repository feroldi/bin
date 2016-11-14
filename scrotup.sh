#!/bin/sh

[ -z "$1" ] && {
    printf '%s\n' "$(basename $0): expected an uploader tool."
    exit 1
}

UPLOAD="$1"

sleep .5
scrot -s -e "mv \$f $HOME/usr/media/img/screenshots/shots/ && \
    $UPLOAD $HOME/usr/media/img/screenshots/shots/\$f | xclip -sel c"

note.sh "$(printf '%b' "\ue1d0") $(xclip -o -sel c)"

