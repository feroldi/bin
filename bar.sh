#!/bin/sh

[ $(pgrep -cx bar.sh) -gt 1 ] && exit 1

. extractcol.sh

BAR_BG="$BG"
BAR_FG="#000000"
GRAD1="#F0F0F0"
GRAD2="#E0E0E0"
#GRAD1="$(xrq color2)"
#GRAD2="$FG"

# Fonts
FONT1='Wuncon Siji:style=Regular:size=7'
FONT2='GohuFont:style=Regular:size=8'

DISPLAY_X=$(xrandr --current | grep '*' | tail -n1 | uniq | awk '{print $1}' | cut -d 'x' -f1)
DISPLAY_Y=$(xrandr --current | grep '*' | tail -n1 | uniq | awk '{print $1}' | cut -d 'x' -f2)

# Panel
PW=$((DISPLAY_X))
PH=13
PX=$((DISPLAY_X - PW))
PY=$((DISPLAY_Y - PH))

print_status()
{
    backg=${3:-$GRAD1}
    foreg=${4:-$BAR_FG}
    printf %s "%{F$foreg} %{B$backg} %{B-}%{+u}%{B$backg} $(printf "$1") $2 %{B-}%{-u}%{B$backg} %{B-}%{F-} "
}

memory_usage()
{
    print_status '\ue020' "$(free -h | grep Mem: | awk "{print \$7}")"
}

temperature()
{
    print_status '\ue01c' "$(acpi -t | awk '{print $4}')"
}

battery_time()
{
    acpi -b | grep -v 'rate information unavailable' | cut -d ' ' -f 5
}

battery()
{
    BAT_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)

    if [ $BAT_LEVEL -ge 80 ]; then
        print_status '\ue1ff' "$BAT_LEVEL [$(battery_time)]" "#2F2" "#060"
    elif [ $BAT_LEVEL -ge 70 ]; then
        print_status '\ue1ff' "$BAT_LEVEL [$(battery_time)]"
    elif [ $BAT_LEVEL -ge 50 ]; then
        print_status '\ue1fe' "$BAT_LEVEL [$(battery_time)]"
    else
        print_status '\ue1fd' "$BAT_LEVEL [$(battery_time)]" "#F22" "#600"
    fi
}

clock()
{
    print_status '\ue26a' "$(date "+%d %b %a %Y")"
    print_status '\ue015' "$(date "+%H:%M")"
}

laptop()
{
    print_status '\ue1d8' T420
}

pomodoro()
{
    pomo_clock=$(pomo.sh clock)
    pomo_status=$(pomo.sh status)
    if [[ "$pomo_status" =~ ^W.* ]]; then
        print_status '\ue00f' "$pomo_clock" "$RED" "#400" # working flash
    elif [[ "$pomo_status" =~ ^B.* ]]; then
        print_status '\ue0aa' "$pomo_clock" "$GREEN" "#040" # break monster
    elif [[ "$pomo_status" =~ ^P.* ]]; then
        print_status '\ue1b8' "$pomo_clock" "$YELLOW" "#440" # pause cat
    fi
}

printf "%s\n" "${PW}x${PH}+${PX}+${PY}"

(
while :
do
    printf '%s\n' " $(laptop)$(pomodoro)%{r}%{U$BAR_BG}$(temperature)$(memory_usage)$(battery)$(clock) "
    sleep 2
done
) | lemonbar -g ${PW}x${PH}+${PX}+${PY} -B "$BAR_BG" -F "$BAR_FG" -d -o 1 -f "$FONT1" -o 1 -f "$FONT2" -u 0

