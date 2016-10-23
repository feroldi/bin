#!/bin/sh

FILE="$HOME/.surf/hist"

[ -e $FILE ] || :> $FILE

URL=$(cat $FILE | menu.sh -p open -c '#a2a2a5')
[ -n "$URL" ] && grep -qx "$URL" "$FILE" && echo "$URL" >> $FILE
echo "$URL"

