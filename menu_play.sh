#!/bin/sh

case "$(printf 'clipboard\nbrowse\nsearch\nplaylist' | \
  menu.sh -c "$(xrq color3)" -p play -l 4)" in
  browse)
    DIR="$(menu_browse.sh ~/usr/media/msc/)"
    [ -n "$DIR" ] && play.sh "$DIR"&
    ;;
  clipboard)
    play.sh "$(xclip -o -sel c)"&
    ;;
  search)
    SEARCH="$(echo | menu.sh -c "$(xrq color3)" -p search)"
    play.sh "ytdl://ytsearch:$SEARCH"
    ;;
  playlist)
    play.sh "https://youtube.com/playlist?list=$(xclip -o -sel c)"
    ;;
esac

