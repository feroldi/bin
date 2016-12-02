#!/bin/sh

case "$(printf 'clipboard\nbrowse' | menu.sh -c "$(xrq color3)" -p play)" in
  browse)
    DIR="$(menu_browse.sh ~/usr/media/msc/)"
    [ -n "$DIR" ] && play.sh "$DIR"&
    ;;
  clipboard)
    play.sh "$(xclip -o -sel c)"&
    ;;
esac

