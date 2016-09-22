#!/usr/bin/env sh

usage() {
    cat >&2 << EOF
Usage:
    $(basename $0) [OPTIONS...] <files...>

Options:
    -h, --help
        shows this screen
EOF
    exit $1
}

test $# = 0 && usage 1

while test $# -gt 0; do
    case $1 in -h|--help) usage 0;; esac
    test -f "$1" || echo "file '$1' doesn't exist, skipping..." >&2
    case $1 in
        *.tar.bz2)   tar xvjf $1     ;;
        *.tar.gz)    tar xvzf $1     ;;
        *.bz2)       bunzip2 $1      ;;
        *.rar)       unrar x $1      ;;
        *.gz)        gunzip $1       ;;
        *.tar)       tar xvf $1      ;;
        *.tbz2)      tar xvjf $1     ;;
        *.tgz)       tar xvzf $1     ;;
        *.tar.*)     tar xf $1       ;;
        *.zip)       unzip $1        ;;
        *.Z)         uncompress $1   ;;
        *.7z)        7z x $1         ;;
        *)           echo "'$1' cannot be extracted via $(basename $0), skipping..." >&2 ;;
    esac
    shift 1
done

