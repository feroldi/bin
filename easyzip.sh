#!/bin/sh

usage()
{
    cat <<EOF >&2
usage: $(basename $0) file
EOF
    exit 1
}

[ -z "$1" ] && usage

zip -9 -y -r -q "$1.zip" "$1"

