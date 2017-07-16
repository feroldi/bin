#!/bin/sh

[ -z "$1" ] && echo 'missing argument [dark | blue]' && exit 1

[ "$1" = "dark" ] && {
  WALLPAPER_PATH="/home/thlst/usr/media/img/tile/epe.png"
  XRES_THEME='colors/vs-dark'
}

[ "$1" = "blue" ] && {
  WALLPAPER_PATH="/home/thlst/usr/media/img/tile/Ana.png"
  XRES_THEME='colors/vs-blue'
}

# switch Xresources colorscheme
printf '#include "%s"\n' "$XRES_THEME" > ~/.xres/theme 

# reload Xresources
xrdb -load ~/.xres/xres && pkill -USR1 '^st$'

# reload bar
pkill bar.sh
bar.sh&
disown

# change background
outdoor.sh -t "$WALLPAPER_PATH" -i '#e0e0e0'

