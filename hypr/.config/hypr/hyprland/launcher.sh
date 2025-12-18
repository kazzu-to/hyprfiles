#! /usr/bin/env bash

command qs -c noctalia-shell ipc call launcher toggle || dms ipc call spotlight toggle

if [[ $? -ne 0 ]]; then
	command rofi -show drun
fi
