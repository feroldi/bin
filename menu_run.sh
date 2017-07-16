#!/bin/sh
dmenu_path | menu.sh -p 'exec' -c "$(xrq color3)" "$@" | ${SHELL:-"/bin/sh"} &
