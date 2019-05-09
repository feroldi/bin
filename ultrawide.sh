#!/bin/sh

setup_ultra_res() {
    xrandr --newmode "2560x1080"  222.00  2560 2720 2992 3424  1080 1083 1093 1119 -hsync -vsync
    xrandr --addmode HDMI-1 "2560x1080"
}

set_ultra() {
    xrandr --auto --output HDMI-1 --left-of LVDS-1 --mode "2560x1080"
}

set_ws_to_ultra() {
    bspc monitor HDMI-1 -d 1 2 3 4 5
    bspc monitor LVDS-1 -d 6 7 8 9 0
}

update_keyboards() {
    setxkbmap -model pc105 -layout us,us -variant altgr-intl,intl -option grp:shifts_toggle,grp_led:caps,compose:menu
    xmodmap ~/.xmodmap
}

reset_monitor() {
    xrandr --auto --output LVDS-1
}

reset_ws() {
    bspc monitor LVDS-1 -d 1 2 3 4 5 6 7 8 9 0
}

if [[ $1 = 'set' ]]; then
    set_ultra
    if [[ $? != 0 ]]; then
        setup_ultra_res && set_ultra
    fi
    set_ws_to_ultra
    update_keyboards
elif [[ $1 = 'reset' ]]; then
    reset_monitor
    reset_ws
    update_keyboards
fi
