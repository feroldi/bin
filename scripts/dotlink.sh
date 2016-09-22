#!/usr/bin/env sh

usage()
{
    cat >&2 <<EOF
usage: $(basename $0) [-h] [-b FILE] </path/from> </path/to>
EOF
    exit 1
}

help_()
{
    cat >&2 <<EOF
USAGE
    $(basename $0) [OPTIONS]... </path/from> </path/to>

DESCRIPTION
    $(basename $0) links files from one directory
    to another.

EXAMPLE
    Link all files from current directory to home,
    ignoring files listed in .gitignore.

        $(basename $0) -b .gitignore . \$HOME

OPTIONS
    -b, --black-list=FILE
        Ignore files/directories matching the ones
        listed in FILE.

    -h, --help
        Show this help.
EOF
    exit 0
}

wrong()
{
    printf '%s\n' "$(basename $0): $1"
    usage
}


while test $# -gt 0
do
    case "$1" in
        -b|--black-list)
            BLACK_LIST="$2"
            shift 2
            ;;
        -h|--help)
            help_
            ;;
        *)
            test -d "$1" || wrong "file $1 doesn't exist, or isn't a directory."
            test -z "$FILE_FROM" && {
                FILE_FROM="$1"
            } || {
                test -z "$FILE_TO" && {
                    FILE_TO="$1"
                } || {
                    usage
                }
            }
            shift 1
            ;;
    esac
done

test -n "$FILE_FROM" || wrong "missing </path/from> argument."
test -n "$FILE_TO" || wrong "missing </path/to> argument."

for FILE in $(ls -A "$FILE_FROM")
do 
    # check whether file is contained in black-list.
    # if so, skip it.
    test -f "$BLACK_LIST" && grep "$FILE" "$BLACK_LIST" >/dev/null && {
        printf '%s\n' "skipping $FILE_FROM/$FILE"
        continue
    }

    printf '%s\n' "linking $FILE_FROM/$FILE -> $FILE_TO/$FILE"
    ln -s "$(realpath "$FILE_FROM/$FILE")" "$FILE_TO/$FILE"
done

