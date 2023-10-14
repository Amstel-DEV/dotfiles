#!/usr/bin/env bash

## Author : Amstel
## Github : Amstel-DEV
## Rofi   : Power Menu


# Current Theme
dir="$HOME/.config/waybar/scripts/power/"
theme='style-sg'

# CMDs
lastlogin="`last $USER | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7`"
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostname`

# Options
hibernate='󰽥'
shutdown='󰐥'
reboot=''
lock=''
suspend='󰏦'
logout='󰍃'
yes='󰄴'
no='󰅚'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "󰀓  $USER@$host" \
		-mesg "󰅐  Last Login: $lastlogin | 󰍹   Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			killall Hyprland && sudo shutdown now
		elif [[ $1 == '--reboot' ]]; then
			killall Hyprland && sudo reboot now
		elif [[ $1 == '--hibernate' ]]; then
			sudo systemctl hibernate
		elif [[ $1 == '--suspend' ]]; then
			sudo mpc -q pause
			sudo amixer set Master mute
			sudo systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == 'hyprland' ]]; then
				killall Hyprland && sudo sddm
			fi
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $hibernate)
		run_cmd --hibernate
        ;;
    $lock)
		if [[ -x '/usr/bin/betterlockscreen' ]]; then
			betterlockscreen -l
		elif [[ -x '/usr/bin/i3lock' ]]; then
			i3lock
		else
			sudo sddm
		fi
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
