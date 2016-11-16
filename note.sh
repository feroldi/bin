#!/bin/sh

DURATION=${2:-3}

. extractcol.sh

BAR_BG="$BG"
BAR_FG="$FG"

FONT1="siji:size=9"
FONT2="-xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso10646-1"

PW=${#1}
PW=$((PW*7+8))
PH=19
PX=0
PY=$((768 - PH))


open_bar()
{
  lemonbar \
    -g ${PW}x${PH}+${PX}+${PY} \
    -B "$BAR_BG" \
    -F "$BAR_FG" \
    -d \
    -f "$FONT1" \
    -f "$FONT2"
}

(echo " $1"; sleep ${DURATION}) | open_bar &

