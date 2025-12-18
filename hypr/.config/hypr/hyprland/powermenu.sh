#!/bin/bash

command qs -c noctalia-shell ipc call sessionMenu toggle || dms ipc call powermenu toggle

if [[ $? -ne 0 ]]; then

	options="Logout\nReboot\nShutdown\nSuspend\nLock"
	
	chosen=$(echo -e "$options" | rofi -dmenu -p "Power Menu")
	
	case $chosen in
	    "Logout")
	        hyprctl dispatch exit
	        ;;
	    "Reboot")
	        systemctl reboot
	        ;;
	    "Shutdown")
	        systemctl poweroff
	        ;;
	    "Suspend")
	        systemctl suspend
	        ;;
	    "Lock")
	        hyprlock
	        ;;
	esac
fi
