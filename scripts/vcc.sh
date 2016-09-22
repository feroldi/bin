#!/usr/bin/env sh

usage() {
    cat >&2 << EOF
Usage:
    $(basename $0) [OPTIONS...]

Options:
    -s, --set=HEX RRGGBB
        sets a new color for index

    -h, --help
        shows this screen
EOF
    exit $1
}

wrong_arg() {
    printf '%s\n' "wrong paramenter for $1: $2"
    usage 1
}

# checks if there are any options
test $# = 0 && wrong_arg "$(basename $0)" "no options were given"

while test $# -gt 0; do
    case "$1" in
        -s|--set)
            ESC_COLOR=$3
            test "$(echo "$3" | head -c1)" = "#" && \
                ESC_COLOR=$(echo "$3" | tail -c+2)
            echo -e "\\e]P$2$ESC_COLOR"
            shift 2
            ;;
        -h|--help)
            usage 0
            ;;
        *)
            usage 1
            ;;
    esac
done

