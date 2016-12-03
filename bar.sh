#!/bin/sh

[ $(pgrep -cx bar.sh) -gt 2 ] && exit 1

. extractcol.sh

BAR_BG="$BG"
BAR_FG="$FG"
ICON_COLOR="#000000"
ICON_BG="$(xrq color8)"

# Fonts
FONT1="siji:size=9"
FONT2="-*-yuki-*-*-*-*-*-*-*-*-*-*-*-*"

# Panel 
PW=190
PH=14
PX=$((1366 - PW))
PY=$((768 - PH))

fmt_icon_message()
{
  printf %s \
    "%{+u}%{F$ICON_COLOR}%{B$ICON_BG} $(printf %b "\u$1") %{B-}%{F-} $2 %{-u} "
}

clock()
{
  fmt_icon_message e26a "$(date "+%d %b %a %Y")"
  fmt_icon_message e081 "$(date "+%H:%M")"
}

(
while :
do
  printf '%s\n' "%{U$ICON_BG}$(clock) "
	sleep 1
done
) | lemonbar -g ${PW}x${PH}+${PX}+${PY}\
  -B "$BAR_BG" -F "$BAR_FG" -d -f "$FONT1" -f "$FONT2" -u 2

