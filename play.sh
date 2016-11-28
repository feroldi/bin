#!/bin/sh

[ $(pgrep -cx play.sh) -gt 1 ] && exit 1

. extractcol.sh

BAR_BG="$BG"
BAR_FG="$FG"
ICON_COLOR="$(xrq color15)"

# Fonts
FONT1="siji:size=9"
FONT2="-xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso10646-1"

# Panel 
PW=240
PH=18
PX=$((1366 - PW - 250)) # offset
PY=$((768 - PH - 2))

put_icon()
{
  printf '%s' "%{F$ICON_COLOR}$(printf %b "\u$1")%{F-}"
}

put_msg()
{
  printf '%s' "%{F$BAR_FG}$1%{F-}"
}

get_prop()
{
  echo "{\"command\": [\"get_property\",\"$1\"]}" | \
    socat - /tmp/mpvsocket 2>/dev/null | \
    jshon -e data -u 2>/dev/null
}

set_prop()
{
  echo "{\"command\": [\"set_property\",\"$1\", $2]}" | \
    socat - /tmp/mpvsocket 2>/dev/null >&2
}

playback_time()
{
  PLAYBACK=$(get_prop playback-time)
  echo $((PLAYBACK / 60))
}

mpv --no-video --no-terminal \
  --input-ipc-server=/tmp/mpvsocket "$1"&

MPV_PID=$!

trap 'kill $MPV_PID 2>/dev/null' 0

(
  while sleep 0.2
  do
    kill -0 $MPV_PID >&2 2>/dev/null || exit
    BUF=""
    BUF+="%{A:b:}$(put_icon e096)%{A}" # backward
    BUF+="%{A:pa:}$(put_icon e09b)%{A}" # pause
    BUF+="%{A:pl:}$(put_icon e09a)%{A}" # play
    BUF+="%{A:f:}$(put_icon e09c)%{A}" # forward
    BUF+=" %{A:e:}$(put_icon e099)%{A} " # exit
    BUF+="$(put_icon e1b1)" # separator
    BUF+="$(put_icon e0fd) $(put_msg "$(get_prop media-title)")"
    printf '%s\n' "$BUF"
  done
) |\
  lemonbar -g ${PW}x${PH}+${PX}+${PY} \
  -B "$BAR_BG" -F "$BAR_FG" -d -f "$FONT1" -f "$FONT2" -u 0 |\
  while read LINE
  do
    case $LINE in
      pa) set_prop pause true
        ;;
      pl) set_prop pause false
        ;;
      e) exit
        ;;
    esac
  done

