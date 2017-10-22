#!/bin/sh
dmenu_path | menu.sh -p 'exec' -c "#202020" "$@" | ${SHELL:-"/bin/sh"} &
