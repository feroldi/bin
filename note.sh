#!/bin/sh

DURATION=${3:-3}

. extractcol.sh

BAR_BG="$BG"
BAR_FG="$FG"
ICON_COLOR="#000000"
ICON_BG="#0f0f0f"

FONT1="siji:size=9"
FONT2="-*-yuki-*-*-*-*-*-*-*-*-*-*-*-*"

PW=${#2}
PW=$((4+PW*7+8))
PH=14
PX=0
PY=$((768 - PH))

fmt_icon_message()
{
  printf %s \
    "%{+u}%{F$ICON_COLOR}%{B$ICON_BG} $(printf %b "\u$1") %{B-}%{F-} $2 %{-u} "
}

open_bar()
{
  lemonbar \
    -g ${PW}x${PH}+${PX}+${PY} \
    -B "$BAR_BG" \
    -F "$BAR_FG" \
    -d \
    -f "$FONT1" \
    -f "$FONT2" \
    -u 2
}

(
  printf '%s\n' "%{U$ICON_BG}$(fmt_icon_message "$1" "$2")"
  sleep ${DURATION}
) | open_bar &

