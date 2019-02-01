#!/bin/sh

xrandr --newmode "2560x1080_58.00"  222.00  2560 2720 2992 3424  1080 1083 1093 1119 -hsync +vsync
xrandr --addmode HDMI-1 "2560x1080_58.00"
xrandr --auto --output HDMI-1 --right-of LVDS-1 --mode "2560x1080_58.00"
