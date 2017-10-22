#!/bin/sh

DURATION=${2:-2}

. extractcol.sh

BAR_BG="$BG"
BAR_FG="$FG"
ICON_COLOR="$BAR_FG"
ICON_BG="$BAR_BG"

# Fonts
FONT1='Wuncon Siji:style=Regular:size=8'
FONT2='GohuFont:style=Regular:size=8'

PW=200
PH=14
PX=0
PY=$((900 - PH))

fmt_icon_message()
{
  printf %s "%{+u}%{F$ICON_COLOR}%{B$ICON_BG}%{B-}%{F-}$1%{-u} "
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
  printf '%s\n' " %{U$ICON_BG}$(fmt_icon_message "$1")"
  sleep ${DURATION}
) | open_bar &

