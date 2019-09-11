#!/bin/sh

[ -z "$1" ] && echo 'missing argument [dark | blue]' && exit 1

if [ "$1" = "dark" ]; then
  WALLPAPER_PATH="/home/thlst/usr/media/img/tile/epe.png"
  XRES_THEME='colors/vs-dark'

  bspc config normal_border_color '#3b3b3b'
  bspc config active_border_color '#d8ad4c'
  bspc config focused_border_color '#d8ad4c'
elif [ "$1" = "blue" ]; then
  WALLPAPER_PATH="/home/thlst/usr/media/img/tile/Ana.png"
  XRES_THEME='colors/vs-blue'

  bspc config normal_border_color '#9D9B9E'
  bspc config active_border_color '#005F87'
  bspc config focused_border_color '#005F87'
else
  exit 1
fi

# switch Xresources colorscheme
printf '#include "%s"\n' "$XRES_THEME" > ~/.xres/theme

# reload Xresources
xrdb -load ~/.xres/xres && pkill -USR1 '^st$'

# reload bar
pkill bar.sh
bar.sh >/dev/null 2>&1 &

# change background
outdoor.sh -t "$WALLPAPER_PATH" -i '#e0e0e0'
