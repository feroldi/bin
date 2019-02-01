#!/bin/sh
dmenu_path | menu.sh -p 'exec' "$@" | ${SHELL:-"/bin/sh"} 1>&2 2>/dev/null &
disown
