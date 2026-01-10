#! /usr/bin/env bash 


paconf='/etc/pacman.conf'

if [[ -f "$paconf" ]]; then
    sed -i 's/#Color/Color/' "$paconf"
    echo "ILoveCandy" >> "$paconf"
fi

###########-------------------------------

lidconf='/etc/systemd/login.conf'

if [[ -f "$lidconf" ]]; then
    sed -i 's/#HandlePowerKey=sleep/HandlePowerKey=sleep/' "$lidconf"
    sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/' "$lidconf"
    sed -i 's/#HandleLidSwitchExternalPower=ignore/HandleLidSwitchExternalPower=ignore/' "$lidconf"
fi
