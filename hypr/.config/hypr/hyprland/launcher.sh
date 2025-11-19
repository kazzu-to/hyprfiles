#! /usr/bin/env bash

command dms ipc call spotlight toggle

if [[ $? -ne 0 ]]; then
	command rofi -show drun
fi
