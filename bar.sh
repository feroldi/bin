#!/bin/sh

[ $(pgrep -cx bar.sh) -gt 2 ] && exit 1

. extractcol.sh

BAR_BG="$BG"
BAR_FG="$FG"
GRAD1="#F0F0F0"
GRAD2="#E0E0E0"
#GRAD1="$(xrq color2)"
#GRAD2="$FG"

# Fonts
FONT1='Wuncon Siji:style=Regular:size=7'
FONT2='GohuFont:style=Regular:size=8'

DISPLAY_X=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
DISPLAY_Y=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)

# Panel
PW=$DISPLAY_X
PH=14
PX=$((DISPLAY_X - PW))
PY=$((DISPLAY_Y - PH))

print_status()
{
  BACKGROUND=${3:-$GRAD1}
  printf %s " %{B$GRAD1} %{B-}%{+u}%{B$BACKGROUND} $1 $2 %{B-}%{-u}%{B$GRAD1} %{B-} "
}

battery()
{
  BAT_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)

  if [ $BAT_LEVEL -ge 80 ]; then
    print_status '' "$BAT_LEVEL [$(acpi | awk '{printf $5 "\n"}')]" "#2F2"
  elif [ $BAT_LEVEL -ge 40 ]; then
    print_status '' "$BAT_LEVEL [$(acpi | awk '{printf $5 "\n"}')]"
  else
    print_status '' "$BAT_LEVEL [$(acpi | awk '{printf $5 "\n"}')]" "#F22"
  fi
}

battery_time()
{
  print_status '' "$(acpi | awk '{printf $5 "\n"}')"
}

clock()
{
  print_status '' "$(date "+%d %b %a %Y")"
  print_status '' "$(date "+%H:%M")"
}

laptop()
{
  print_status '' T420
}

(
while :
do
  printf '%s\n' " $(laptop)%{r}%{U$BAR_BG}$(battery)$(clock) "
  sleep 2
done
) | lemonbar -g ${PW}x${PH}+${PX}+${PY} -B "$BAR_BG" -F "$BAR_FG" -d -f "$FONT1" -f "$FONT2" -u 0

