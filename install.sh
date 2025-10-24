
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
stowupdate
pkg
bootloader
enable_services
hyprplugins
gsettings set org.gnome.desktop.interface gtk-theme "Midnight-Gray"
