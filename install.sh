#!/usr/bin/env bash 

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


#stowupdate
pkg
enable_services
gsettings set org.gnome.desktop.interface gtk-theme "Midnight-Gray"
