#!/bin/sh

TOOL=$(dmenu_path | menu.sh -p run)
[ -z "$TOOL" ] && exit 1

DIR="$(menu_browse.sh)"

[ -n "$DIR" ] && $TOOL "$DIR" 2>/dev/null >&2

