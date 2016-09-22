#!/usr/bin/env sh

FILE="$HOME/.surf/hist"

test -e $FILE || :> $FILE

URL=$(cat $FILE | menu.sh -p open -c '#a2a2a5')
test -n "$URL" && \
    test "$(grep -x $URL $FILE | wc -l)" -eq 0 && echo "$URL" >> $FILE
echo "$URL"

