#!/bin/sh

usage() {
    cat >&2 << EOF
USAGE
    $(basename $0) [OPTIONS...] </path/to/img>

OPTIONS
    -b, --blur=NUM
        sets image blur.

    -t, --tile
        tiles image (fills by default).

    -s, --solid=COLOR
        sets a solid color.

    -i, --tint=COLOR
        colorize the background.
EOF
    exit $1
}

REND=-fill
BLUR=0

while test $# -gt 0; do
    case "$1" in
        -b|--blur)
            BLUR="$2"
            shift 2
            ;;
        -t|--tile)
            REND=-tile
            shift 1
            ;;
        -s|--solid)
            SOLID="$2"
            shift 2
            break
            ;;
        -i|--tint)
            TINT="$2"
            shift 2
            break
            ;;
        -h|--help)
            usage 0
            ;;
        *)
            IMG="$1"
            shift 1
            ;;
    esac
done

wrong_arg() {
    printf '%s\n' "$(basename $0): wrong argument for file: $1" >&2
    usage 1
}

test -n "$SOLID" && {
    hsetroot -solid "$SOLID"
    cat << EOF >$HOME/.env/rootimg
#!/bin/sh
hsetroot -solid '$SOLID'

EOF
} || {
    test -n "$IMG" || wrong_arg "no file was given"
    test -f "$IMG" || wrong_arg "$IMG doesn't exist"

    hsetroot $REND $IMG -blur $BLUR $([ -n "$TINT" ] && \
                    printf '%s' "-tint $TINT" || printf '%s' "")


    cat << EOF >$HOME/.env/rootimg
#!/bin/sh
hsetroot $REND $IMG -blur $BLUR $(test -n "$TINT" && printf '%s' "-tint '$TINT'" \
                                                  || printf '%s' "")

EOF
}

chmod a+x $HOME/.env/rootimg

