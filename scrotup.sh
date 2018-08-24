#!/bin/sh

if [ -z "$1" ]; then
  UPLOAD=$(cat<<EOF | menu.sh -p uploader
clipshot.sh
imgur.sh
iotek.sh
EOF
  )
fi

${UPLOAD:=clipshot.sh}

sleep .5
scrot -s -e "mv \$f $HOME/usr/media/img/screenshots/shots/ && \
    $UPLOAD $HOME/usr/media/img/screenshots/shots/\$f"

note.sh "shot taken"
