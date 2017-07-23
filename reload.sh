#!/bin/sh

[ -z "$1" ] && echo 'missing argument [dark | blue]' && exit 1

[ "$1" = "dark" ] && {
  WALLPAPER_PATH="/home/thlst/usr/media/img/tile/epe.png"
  XRES_THEME='colors/vs-dark'
  cat > bin/focus.sh << EOF
#!/bin/sh
# vs-dark
exec ufocus -f '#005f87' -u "#000f17" -b1
EOF
}

[ "$1" = "blue" ] && {
  WALLPAPER_PATH="/home/thlst/usr/media/img/tile/Ana.png"
  XRES_THEME='colors/vs-blue'

  # change windows' border
  cat > bin/focus.sh << EOF
#!/bin/sh
# vs-blue
exec ufocus -f '#005f87' -u "#9d9b9e" -b1
EOF
}

# switch Xresources colorscheme
printf '#include "%s"\n' "$XRES_THEME" > ~/.xres/theme

# reload Xresources
xrdb -load ~/.xres/xres && pkill -USR1 '^st$'

# reload bar
pkill bar.sh
nohup bar.sh > /dev/null 2>&1 &

# change background
outdoor.sh -t "$WALLPAPER_PATH" -i '#e0e0e0'

pkill ufocus
nohup focus.sh > /dev/null 2>&1 &
