#!/bin/sh

TOOL=$(dmenu_path | menu.sh -c "$(xrq color3)" -p run)
[ -z "$TOOL" ] && exit 1

DIR="$(menu_browse.sh)"

[ -n "$DIR" ] && $TOOL "$DIR" 2>/dev/null >&2

