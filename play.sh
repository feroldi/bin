#!/bin/sh

SOCKET=/tmp/mpvsocket

BAR_BG="$(xrq background)"
BAR_FG="$(xrq foreground)"
ICON_COLOR="#000000"
#ICON_BG="$(xrq color6)"
ICON_BG="#005f87"

# Fonts
FONT1="siji:size=9"
FONT2='lime:size=8'

# Panel 
PW=320
PH=14
PX=$((1366 - PW - 220)) # offset
PY=$((768 - PH))

fmt_icon_message()
{
  printf '%s' \
    "%{+u}%{F$ICON_COLOR}%{B$ICON_BG} $(printf %b "\u$1") %{B-}%{F-} $2 %{-u} "
}

fmt_button()
{
  printf '%s' \
    "%{A:$1:}%{+u}%{F$ICON_COLOR}%{B$ICON_BG}$(printf %b "\u$2")%{B-}%{F-}%{A}%{-u}"
}

get_prop()
{
  echo "{\"command\": [\"get_property\",\"$1\"]}" | \
    socat - $SOCKET 2>/dev/null | \
    jshon -e data -u 2>/dev/null
}

set_prop()
{
  echo "{\"command\": [\"set_property\",\"$1\", $2]}" | \
    socat - $SOCKET 2>/dev/null >&2
}

mpv_action()
{
  echo "$@" | socat - $SOCKET 2>/dev/null >&2
}

[ -S $SOCKET ] && {
  mpv_action loadfile "\"$1\"" append-play
  [ -e "$1" ] && {
    note.sh e0fd "added \`$(basename "$1")\` to playlist"
  } || {
    note.sh e0fd "added \`$(youtube-dl -e $1)\` to playlist"
  }
  exit 0
}

mpv --no-video --no-terminal \
  --input-ipc-server=$SOCKET "$1"&
MPV_PID=$!

exit_guard()
{
  kill $MPV_PID
  rm $SOCKET
}

trap 'exit_guard' 0

(sleep 5; set_prop loop true)&

panel_status()
{
  # previous
  fmt_button bb e096

  # backward seek
  fmt_button b e097

  # play/pause
  [ $(get_prop pause) = true ] && {
    fmt_button pl e09a
  } || {
    fmt_button pa e09b
  }

  # forward seek
  fmt_button f e09d

  # next
  fmt_button ff e09c

  # exit
  fmt_button e e099

  printf '  '

  # headphones n title
  fmt_icon_message e0fd "$(get_prop media-title)"
}

(
  while sleep 1
  do
    kill -0 $MPV_PID || exit
    printf '%s\n' "%{U$ICON_BG}$(panel_status) "
  done
) |\
  lemonbar -g ${PW}x${PH}+${PX}+${PY} \
  -B "$BAR_BG" -F "$BAR_FG" -d -f "$FONT1" -f "$FONT2" -u 2 |\
  while read LINE
  do
    case $LINE in
      b) mpv_action seek -10
        ;;
      bb) mpv_action playlist-prev weak
        ;;
      f) mpv_action seek 10
        ;;
      ff) mpv_action playlist-next weak
        ;;
      pa) set_prop pause true
        ;;
      pl) set_prop pause false
        ;;
      e) kill $MPV_PID
        ;;
    esac
  done

