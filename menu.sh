#!/usr/bin/env sh

usage() {
    cat >&2 <<EOF
Usage:
    $(basename $0) [-p prompt] [OPTIONS]...

Options:
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
        *)
            break
            ;;
    esac
done

. extractcol.sh

dmenu -fn 'GohuFont:style=Regular:size=8' -p "$PROMPT" \
  -sb "$FG" -sf "$BG" -nb "$BG" -nf "$FG" -b "$@"
