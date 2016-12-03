#!/bin/sh

[ -n "$1" ] && DIR="$1" || DIR=~/

(
while [ -d "$DIR" ]; do
  cd "$DIR" && \
    DIR="$(printf '%s\n%s' ".." "$(ls -F)" \
    | menu.sh -c "$(xrq color3)" -p "$TOOL" -l 10)"
  [ -z "$DIR" ] && exit 1
done

printf '%s\n' "$(pwd)/$DIR"
)


