#!/bin/sh

database=$HOME/usr/dev/burnout/burnout.sqlite3

cd $HOME/usr/dev/burnout

case $1 in
    track)
        poetry run burnout/main.py --database-path $database track
        ;;
    finish)
        [[ -n "$2" ]] || exit 1
        tempfile=$(mktemp)
        $EDITOR $tempfile
        poetry run burnout/main.py --database-path $database finish --detail "$(cat $tempfile)" --tag $2
        ;;
    status)
        poetry run burnout/main.py --database-path $database status --today --per-tag
        ;;
esac
