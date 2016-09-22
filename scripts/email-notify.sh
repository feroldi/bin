#!/usr/bin/env sh

get_mails() {
    python scripts/gmail "wow"
}

MAILS=$(get_mails)

while true; do
    sleep 20
    NMAILS=$(get_mails)

    if [ "$NMAILS" -gt "$MAILS" ]; then
        notify_bar alert "072" "You have $((NMAILS - MAILS)) new mails" 20
        MAILS=$NMAILS
    fi
done
