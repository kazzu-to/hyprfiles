#!/usr/bin/env bash 


# Ask for the password up front and refresh every minute.
sudo -v
# Start a background job to refresh the timestamp until the script exits.
( while true; do sudo -n true; sleep 60; done ) &
KEEPALIVE_PID=$!

# Ensure we kill the background job on exit
trap 'kill $KEEPALIVE_PID' EXIT


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
sudo pacman -S stow --noconfirm --needed

#cprepo(){
#	echo -e "${GREEN}cloning hyprfiles${NC}"	
#	cd $HOME
#	sudo pacman -S git stow --noconfirm --needed 
#	git clone https://github.com/kazzu-to/hyprfiles
#	
#	if [[ $? -ne 0 ]]; then
#		echo -e  "${RED}could not clone repo${NC}"
#		exit 1
#	fi
#}

stowupdate(){
	command stow sys 
	cd $HOME 
 	if ! sysupdate; then
    		echo -e "${RED}Couldn’t run sysupdate${NC}" >&2
    		exit 2
  	fi
}

pkg(){
	if command -v package-install &>/dev/null; then
		if ! package-install; then
     			 echo -e "${RED}Problem installing packages${NC}" >&2
     			 exit 3
    		fi
	else 
		echo -e "${RED}package-install not found at ~/.local/bin/ -check hyprfiles/sys/.local/bin${NC}"
	fi
}

enable_services(){
	list=(bluetooth ly ufw)
	for ser in "${list[@]}" ; do
		if ! sudo systemctl enable "$ser" --now; then
			echo -e "${RED}Couldn’t enable $svc${NC}"
		fi
	done
}

grub() {
	if [[ -f $HOME/.local/bin/grub_install ]]; then
		sudo chmod +s $HOME/.local/bin/grub_install
		sudo $HOME/.local/bin/grub_install
	else 
		stow sys 
		if [[ $? -eq 0 ]]; then
			grub
		else
			echo -e "${RED}'sys' folder isn't stow'ed yet${NC}"
		fi
	fi
}


#stowupdate
pkg
enable_services
gsettings set org.gnome.desktop.interface gtk-theme "Midnight-Gray"
grub
