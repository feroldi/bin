#!/bin/sh
dmenu_path | menu.sh -p 'exec' "$@" | ${SHELL:-"/bin/sh"} &
