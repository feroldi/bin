#!/usr/bin/env sh

CONFIG_FILE="$HOME/.fterm"

SIZE="72x25"

POS_X=(9 463 917)
POS_Y=(10 390)

if [ -r $CONFIG_FILE ]; then
    X=$(cat $CONFIG_FILE | sed 's/\([1-3]\) [1-2]/\1/')
    Y=$(cat $CONFIG_FILE | sed 's/[1-3] \([1-2]\)/\1/')

    urxvt -g $SIZE+${POS_X[$X]}+${POS_Y[$Y]} -name floating_urxvt &
    
    if [ $X = 3 ]; then
        if [ $Y = 2 ]; then
            echo "1 1" > $CONFIG_FILE
        else
            echo "1 $((Y+1))" > $CONFIG_FILE
        fi
    else
        echo "$((X+1)) $Y" > $CONFIG_FILE
    fi
else
    echo "1 1" > $CONFIG_FILE
    ./$0
fi
