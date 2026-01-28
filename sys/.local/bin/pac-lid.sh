#! /usr/bin/env bash 


paconf='/etc/pacman.conf'

if [[ -f "$paconf" ]]; then
    sudo sed -i 's/#Color/Color/' "$paconf"
    #echo "ILoveCandy" | sudo tee -a "$paconf"
fi

###########-------------------------------

lidconf='/etc/systemd/login.conf'

if [[ -f "$lidconf" ]]; then
    sudo sed -i 's/#HandlePowerKey=sleep/HandlePowerKey=sleep/' "$lidconf"
    sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/' "$lidconf"
    sudo sed -i 's/#HandleLidSwitchExternalPower=ignore/HandleLidSwitchExternalPower=ignore/' "$lidconf"
fi
