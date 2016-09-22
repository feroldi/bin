#!/usr/bin/env sh

cat $HOME/.xres/colors/$1 | grep 'color' | sed 's/*color[0-9]*:[ ]*//' | hex2col
