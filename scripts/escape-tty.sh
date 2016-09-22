#!/usr/bin/env sh


exit_msg() {
    echo "error: $1" >&2
    exit 1
}

#tty | grep tty >/dev/null || exit_msg "effects don't apply in $(tty)"

COLS=$(cat $XRES/$(scripts/curcol.sh))

get_def() {
    test "$(echo $1 | head -c1)" = "#" && {
        echo $1
    } || {
        echo $COLS | grep -w1 "#define $1" | tail -c+$(echo "#define $1 " | wc -c)
    }
}

get_col() {
    echo "$1" | sed 's/\*color\([0-9]*\).*\(#[0-9a-zA-Z]*\).*/\1 \2/'
}

echo $COLS | while read LINE; do
    #echo $LINE | grep color >/dev/null || continue
    get_col $LINE | read IDX RRGGBB
    echo $IDX $RRGGBB
    #./scripts/vcc.sh -s "$idx" "$(get_def $col)"
done

