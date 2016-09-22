#!/usr/bin/env sh

usage()
{
    cat <<EOF >&2
usage: $0 <file> [| xclip -sel c]
EOF
        exit "$1"
}

wrong()
{
    printf '%s\n' "$0: $1" >&2
    usage 1
}

test -n "$1" || wrong "must specify a file."
test -e "$1" || wrong "file doesn't exist."

curl -sT- https://p.iotek.org < "$1"


