#!/bin/bash

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

