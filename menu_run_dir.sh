#!/bin/sh

TOOL=$(dmenu_path | menu.sh -c "$(xrq color3)" -p run)
[ -z "$TOOL" ] && exit 1

DIR=~/

(
    while [ -d "$DIR" ]; do
        cd "$DIR" && \
            DIR="$(printf '%s\n%s' ".." "$(ls)" \
            | menu.sh -c "$(xrq color3)" -p "$TOOL" -l 10)"
        [ -z "$DIR" ] && exit 1
    done

    $TOOL "$DIR" 2>/dev/null >&2
)


