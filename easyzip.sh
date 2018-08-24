#!/bin/sh

usage()
{
    cat <<EOF >&2
usage: $(basename $0) </path> <output>
EOF
    exit 1
}

[ -z "$1" ] && usage

zip -9 -y -r -q "$2.zip" "$1"

