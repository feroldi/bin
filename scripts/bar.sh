#!/usr/bin/env sh

test $(pgrep -cx lemonbar) = 1 && exit 1

. $HOME/scripts/extractcol.sh

BAR_BG="$BG"
BAR_FG="$FG"
ICON_COLOR="$BLUE"

# Fonts
FONT1="siji:size=9"
FONT2="-xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso10646-1"

# Panel 
PW=250 # 1366
PH=19 # 24
PX=$((1366 - PW)) # 22
PY=$((768 - PH)) # 10

clock() {
  d=$(date "+%d %b %a %Y")
  c=$(date "+%H:%M")
  echo "%{F$ICON_COLOR}$(printf '%b' "\ue1a2")%{F$BAR_FG}${d}    %{F$ICON_COLOR}$(printf '%b' "\ue018")%{F$BAR_FG}${c}"
}

pow() {
	FOLD="/sys/class/power_supply"
	val=$(if [ -d $FOLD/BAT* ]; then cat $FOLD/BAT*/capacity; fi)
	pow=$(if [ $(cat $FOLD/AC*/online) = 1 ];\
        then echo "$(printf '%b' "\ue200")"; else echo "$(printf '%b' "\ue201")";fi;)
	echo "%{F$ICON_COLOR}${pow}%{F$BAR_FG}${val}"
}

while :; do 
    echo "  %{c}$(pow)    $(clock) "
	sleep 1
 done | lemonbar -g ${PW}x${PH}+${PX}+${PY}\
     -B "$BAR_BG" -F "$BAR_FG" -p -d -f "$FONT1" -f "$FONT2"

