 # ______             __               ______    __                         __     
# /      \           |  \             /      \  |  \                       |  \    
#|  ▓▓▓▓▓▓\__    __ _| ▓▓_    ______ |  ▓▓▓▓▓▓\_| ▓▓_    ______   ______  _| ▓▓_   
#| ▓▓__| ▓▓  \  |  \   ▓▓ \  /      \| ▓▓___\▓▓   ▓▓ \  |      \ /      \|   ▓▓ \  
#| ▓▓    ▓▓ ▓▓  | ▓▓\▓▓▓▓▓▓ |  ▓▓▓▓▓▓\\▓▓    \ \▓▓▓▓▓▓   \▓▓▓▓▓▓\  ▓▓▓▓▓▓\\▓▓▓▓▓▓  
#| ▓▓▓▓▓▓▓▓ ▓▓  | ▓▓ | ▓▓ __| ▓▓  | ▓▓_\▓▓▓▓▓▓\ | ▓▓ __ /      ▓▓ ▓▓   \▓▓ | ▓▓ __ 
#| ▓▓  | ▓▓ ▓▓__/ ▓▓ | ▓▓|  \ ▓▓__/ ▓▓  \__| ▓▓ | ▓▓|  \  ▓▓▓▓▓▓▓ ▓▓       | ▓▓|  \
#| ▓▓  | ▓▓\▓▓    ▓▓  \▓▓  ▓▓\▓▓    ▓▓\▓▓    ▓▓  \▓▓  ▓▓\▓▓    ▓▓ ▓▓        \▓▓  ▓▓
# \▓▓   \▓▓ \▓▓▓▓▓▓    \▓▓▓▓  \▓▓▓▓▓▓  \▓▓▓▓▓▓    \▓▓▓▓  \▓▓▓▓▓▓▓\▓▓         \▓▓▓▓ 
#                                                                                  
#                                                                                  
#                                                                                  


#!/bin/sh
# NOT USED ON OLDASUS-debiansid.
# General stuff
/nix/store/$(ls -la /nix/store | grep 'mate-polkit' | grep '4096' | awk '{print $9}' | sed -n '$p')/libexec/polkit-mate-authentication-agent-1 &
feh --bg-fill /home/will/Pictures/sysicon/wallpapersg.JPG &
copyq &
#dunst &
# fcitx5 -d &
/home/will/.dwm/lowbatremind.sh &
xrdb -merge ~/.Xresources &
# oneko -fg red -sakura -position -50 &
thunar --daemon &
# xsetroot for dwm

# Show Input method

print_ime(){
    MODE=$(fcitx5-remote -n)
    if [ "$MODE" = "keyboard-us" ]; then
	printf " :us"
    elif [ "$MODE" = "pinyin" ]; then
	printf " :zh"
    elif [ "$MODE" = "rime" ]; then
	printf " :ZH"
    elif [ "$MODE" = "mozc" ]; then
	printf " :jp"
    fi
}

# caffeine
print_caffeine(){
    MODE=$(xset -q | grep 'DPMS is' | awk '{print $3}')
    if [ "$MODE" = "Disabled" ]; then
        printf " : 零"
    elif [ "$MODE" = "Enabled" ]; then
        printf " : 鈴"
    fi
}

# dwm_date

print_date(){
	echo $(date "+%D 愈 %T")
}

# by joestandring/dwm-bar

dwm_battery () {
    # Change BAT1 to whatever your battery is identified as. Typically BAT0 or BAT1
    CHARGE=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    printf "%s" "$SEP1"
    if [ "$IDENTIFIER" = "unicode" ]; then
        if [ "$STATUS" = "Charging" ]; then
            printf "🔌 %s%% %s" "$CHARGE" "$STATUS"
        else
            printf "🔋 %s%% %s" "$CHARGE" "$STATUS"
        fi
    else
        if [ "$STATUS" = "Charging" ]; then
            printf "ﴞ %s%% %s" "$CHARGE" 
        else
            printf " %s%% %s" "$CHARGE" 
        fi
    fi
    printf "%s\n" "$SEP2"
}

# bat_time () {
  # acpi | grep 'Battery 0' | grep  -Eo '[0-9][0-9]:[0-9][0-9]'
# }

dwm_alsa () {
	STATUS=$(amixer sget Master | tail -n1 | sed -r "s/.*\[(.*)\]/\1/")
    VOL=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/")
    printf "%s" "$SEP1"
    if [ "$IDENTIFIER" = "unicode" ]; then
    	if [ "$STATUS" = "off" ]; then
	            printf "🔇"
    	else
    		#removed this line becuase it may get confusing
	        if [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
	            printf "🔈 %s%%" "$VOL"
	        elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
	            printf "🔉 %s%%" "$VOL"
	        else
	            printf "🔊 %s%%" "$VOL"
	        fi
		fi
    else
    	if [ "$STATUS" = "off" ]; then
    		printf "MUTE"
    	else
	        # removed this line because it may get confusing
	        if [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
	            printf "奔 %s%%" "$VOL"
	        elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
	            printf "墳 %s%%" "$VOL"
	        elif [ "$VOL" = "0" ]; then
	            printf "婢 %s%%" "$VOL"
	        else
	            printf " %s%%" "$VOL"
        	fi
        fi
    fi
    printf "%s\n" "$SEP2"
}

while true
do
    xsetroot -name " $(print_caffeine) |$(print_ime)|$(dwm_alsa)|$(print_date)|$(dwm_battery)"
    sleep 1 
done

