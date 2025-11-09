
#!/usr/bin/env bash

# Ask for the password up front and refresh every minute
sudo -k
sudo -v
# Start a background job to refresh the sudo timestamp until the script exits
( while true; do sudo -n true; sleep 60; done ) &
KEEPALIVE_PID=$!

# Ensure we kill the background job on exit
trap 'kill $KEEPALIVE_PID' EXIT

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# --- Install stow ---
sudo pacman -S stow --noconfirm --needed

# --- Functions ---
stowupdate() {
    default_path="$HOME/hyprfiles"
    read -ep "$(echo -e "${GREEN}Enter path of cloned hyprfiles repo [${default_path}]: ${NC}")" loc
    loc=${loc:-$default_path}
    cd loc
    stow sys DankMaterualShell fastfetch fish bash gtk-theme kitty nvim qt-theme 

    cd "$loc" || { echo -e "${RED}Path not found: $loc${NC}"; exit 1; }

    command stow sys

    if [[ -f "$HOME/.local/bin/sysupdate" ]]; then
        echo -e "${GREEN}Running sysupdate${NC}"
        bash "$HOME/.local/bin/sysupdate"
    else
        echo -e "${RED}sysupdate script not found${NC}"
        exit 2
    fi
}

pkg() {
    if [[ -f "$HOME/.local/bin/package-install" ]]; then
        echo -e "${GREEN}Installing packages${NC}"
        sudo -H bash "$HOME/.local/bin/package-install"
    else
        echo -e "${RED}package-install not found at ~/.local/bin/${NC}"
        exit 4
    fi
}

enable_services() {
    list=(bluetooth ly ufw)
    for svc in "${list[@]}"; do
        if ! sudo systemctl enable "$svc"; then
            echo -e "${RED}Couldn’t enable $svc${NC}"
        fi
    done
}

grub() {
    if [[ -f "$HOME/.local/bin/grub_install" ]]; then
        sudo -H bash "$HOME/.local/bin/grub_install"
    else
        echo -e "${RED}'sys' folder isn't stow'ed yet${NC}"
        exit 5
    fi
}

refind() {
    if [[ -f "$HOME/.local/bin/refind_install" ]]; then
        sudo -H bash "$HOME/.local/bin/refind_install"
    else
        echo -e "${RED}failed to run refind_install${NC}"
        exit 6
    fi
}

bootloader() {
    read -ep "$(echo -e "${RED}Which bootloader to install (refind/grub) [refind]: ${NC}")" choice
    choice=${choice:-refind}
    case "$choice" in
        refind) refind ;;
        grub) grub ;;
        *) echo -e "${RED}Invalid input${NC}" ;;
    esac
}

hyprplugins() {
    hyprpm update
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    hyprpm update
    hyprpm enable hyprexpo
    hyprctl reload
}

# --- Run everything ---
running_everything() {
	echo -e "${GREEN}Choose what to install/enable:"
	echo -e "1) stow 'sys' folder and update system"
	echo -e "2) Install all packages"
	echo -e "3) Enable ly, ufw & bluwtooth"
	echo -e "4) Install hyprplugins and enable hyprexpo"
	echo -e "5) Do all above & set gtk theme to Colloid-dark"
	echo -e "6) Exit${NC}"
	
	read -ep "$(echo -e "${GREEN}Select a option from above: ${NC}")" inp
}

while true; do
	running_everything
	case "$inp" in
		1)
			stowupdate
			break ;;
		2)
			pkg 
			break;;
		3)
			enable_services 
			break ;;
		4)
			hyprplugins 
			break ;;
		5)
			stowupdate
			pkg
			bootloader
			enable_services
			hyprplugins
			gsettings set org.gnome.desktop.interface gtk-theme "Colloid-Dark"
			break ;;
		6)
			echo -e "${RED} Exiting..${NC}"
			exit 0 ;;
		*)
			echo -e "${RED}choose a vaild option${NC}"
			;;
	esac
done
