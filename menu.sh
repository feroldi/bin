#!/usr/bin/env sh

usage() {
    cat >&2 <<EOF
Usage:
    $(basename $0) [-c color] -[p prompt] [OPTIONS]...

Options:
    -c, --color
        sets selection color

    -p, --prompt
        sets menu prompt to be displayed
EOF
    exit $1
}

test $# -eq 0 && usage 1

while test $# -gt 0; do
    case "$1" in
        -p|--prompt)
            PROMPT="$2"
            shift 2
            ;;
        -c|--color)
            COL="$2"
            shift 2
            ;;
        *)
            break
            ;;
    esac
done

dmenu -fn 'Consolas:size=8' -p "$PROMPT" -sb "$COL" \
    -sf '#000000' -nb '#000000' -b "$@" 

