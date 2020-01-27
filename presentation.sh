#!/bin/sh

# Sets up the 0 desktop to the VGA-1 video output for presentations.

if [[ $1 = 'set' ]]; then
    bspc monitor LVDS-1 -d 1 2 3 4 5 6 7 8 9
    bspc monitor VGA-1 -d 0
elif [[ $1 = 'reset' ]]; then
    bspc monitor LVDS-1 -d 1 2 3 4 5 6 7 8 9 0
fi
