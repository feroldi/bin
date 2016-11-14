#!/bin/sh

[ $(pgrep -cx bar.sh) -gt 2 ] && exit 1

. extractcol.sh

BAR_BG="#00000000"
BAR_FG="$FG"
ICON_COLOR="$(xrq color15)"

# Fonts
FONT1="siji:size=9"
FONT2="-xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso10646-1"

# Panel 
PW=250 # 1366
PH=19 # 24
PX=$((1366 - PW)) # 22
PY=$((768 - PH)) # 10

clock()
{
  DATE=$(date "+%d %b %a %Y")
  TIME=$(date "+%H:%M")
  BUFFER+="%{F$ICON_COLOR}$(printf '%b' "\ue1a2")%{F$BAR_FG}$DATE"
  BUFFER+="    "
  BUFFER+="%{F$ICON_COLOR}$(printf '%b' "\ue018")%{F$BAR_FG}$TIME"
  printf '%s\n' "$BUFFER"
}

pow()
{
	FOLD="/sys/class/power_supply"
	BAT_CAP=$([ -d $FOLD/BAT* ] && cat $FOLD/BAT*/capacity || echo none)
	ICON=$([ "$(cat $FOLD/AC*/online)" -eq 1 ] && \
        printf '%b' "\ue200" ||  printf '%b' "\ue201")
	echo "%{F$ICON_COLOR}$ICON%{F$BAR_FG}$BAT_CAP"
}

while :; do 
    printf '%s\n' "  %{c}$(pow)    $(clock) "
	sleep 1
 done | lemonbar -g ${PW}x${PH}+${PX}+${PY}\
     -B "$BAR_BG" -F "$BAR_FG" -p -d -f "$FONT1" -f "$FONT2"

