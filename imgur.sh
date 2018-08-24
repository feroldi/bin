#!/bin/sh
#
# Upload image(s) to imgur.com
# Copyright (C) 2014  Vivien Didelot <vivien@didelot.org>
# Licensed under GPL version 3, see http://www.gnu.org/licenses/gpl.txt
#
# Requires "jshon":
#   http://kmkeen.com/jshon/

KEY=2403c0205842c3b

die()
{
  printf '%s\n' "$(basename $0): $1" >&2
  exit 1
}

# Syntax check
[ $# -lt 1 ] && die "usage: $(basename $0) <file>... (use - for stdin)"

# Upload every file given as argument
for IMG in "$@"; do
  RESP="$(curl -sS -H "Authorization: Client-ID $KEY" \
    -F "image=@$IMG"  "https://api.imgur.com/3/image.json" 2>&1)"
  [ $? -ne 0 ] && die "$IMG: $RESP"

  URL=$(echo "$RESP" | jshon -Q -e data -e link -u)
  [ -z "$URL" ] && die "$IMG: `echo "$RESP" | jshon -e rsp -e image -e error_msg -u`"

  printf '%s\n' "$URL" | xclip -sel c
done

