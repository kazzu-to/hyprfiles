#! /usr/bin/env bash

command dms ipc call clipboard toggle 

if [[ $? -ne 0 ]]; then
	cliphist list | rofi -dmenu | cliphist decode | wl-copy
fi
