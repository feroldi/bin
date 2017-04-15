#!/bin/sh

xrdb -load ~/.xres/xres
pkill -USR1 '^st$'
pkill -USR1 lemonbar

