#!/bin/sh

setxkbmap -model pc104 -layout $1 -variant intl
xmodmap $HOME/.xmodmap
