#!/bin/sh
#
# Upload image(s) to imgur.com
# Copyright (C) 2014  Vivien Didelot <vivien@didelot.org>
# Licensed under GPL version 3, see http://www.gnu.org/licenses/gpl.txt
#
# Requires "jshon":
#   http://kmkeen.com/jshon/
#
# Alternatives, which suck:
#   http://imgur.com/tools/imgurbash.sh
#   https://raw.githubusercontent.com/JonApps/imgur-screenshot/master/imgur-screenshot.sh
#
# Usage:
#   imgur <file>...
#   Specify <file> as '-' for standard input.
#
# Examples:
#
# * Upload several images:
#   imgur foo.png bar.png
#
# * Take a screenshot and upload it:
#   import png:- | imgur -
#
# * Copy the url to clipboard:
#   imgur <file> | xclip
#
# * Open the result in a web browser:
#   imgur <file> | xargs firefox
#
# * Quick use (no installation):
#   curl -s https://gist.githubusercontent.com/vivien/9768953/raw/imgur | sh -s <file>

KEY=2403c0205842c3b

die () {
  echo "$1" >&2
  exit 1
}

# Syntax check
test $# -lt 1 && die "usage: imgur <file>... (use - for stdin)"

# Upload every file given as argument
for IMG in "$@"
do
  # A more verbose version of `curl -s [...] | jshon -Q -e rsp -e image -e original_image -u`

  RESP="$(curl -sS -H "Authorization: Client-ID $KEY" -F "image=@$IMG"  "https://api.imgur.com/3/image.json" 2>&1)"
  test $? -ne 0 && die "$IMG: $RESP"

  URL=$(echo "$RESP" | jshon -Q -e data -e link -u)
  test -z "$URL" && die "$IMG: `echo "$RESP" | jshon -e rsp -e image -e error_msg -u`"

  echo $URL
done

# vim: et ts=2 sw=2

