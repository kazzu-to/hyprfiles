
#!/usr/bin/env bash
set -Eeuo pipefail

# ================== SUDO KEEPALIVE ==================
sudo -k
sudo -v
( while true; do sudo -n true; sleep 60; done ) &
KEEPALIVE_PID=$!
trap 'kill $KEEPALIVE_PID 2>/dev/null || true' EXIT

# ================== COLORS ==================
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
NC=$'\033[0m'

trap 'echo -e "\n${RED}Error on line $LINENO.${NC}"' ERR

# ================== USER ==================
user=${SUDO_USER:-$USER}
user_home=$(getent passwd "$user" | cut -d: -f6)

# ================== DEP ==================
sudo pacman -Syu stow --noconfirm --needed

# =====================================================
# ================= INSTALL FUNCTIONS =================
# =====================================================

stowupdate() {
    default_path="$user_home/hyprfiles/"
    read -ep "$(echo -e "${GREEN}Hyprfiles path [${default_path}]: ${NC}")" loc
    loc=${loc:-$default_path}

    cd "$loc" || exit 1
    stow sys hypr fastfetch swappy fish kitty matugen DankMaterualShell nvim rofi noctalia

    bash "$user_home/.config/hypr/hyprland/xf86.sh"
    sudo -u "$user" bash "$user_home/.local/bin/sysupdate"
}

pkg() {
    sudo -u "$user" bash "$user_home/.local/bin/package-install"

    [[ ! -d "$user_home/.config/quickshell/overview" ]] &&
        git clone https://github.com/Shanu-Kumawat/quickshell-overview \
        "$user_home/.config/quickshell/overview"
}

enable_services() {
  servs=(bluetooth ly ufw)
  echo -e "Services to be enabled: ${servs[@]}"
  read -ra servsinp -p "${Yellow}Enter other services...${NC}"       # -a takes user input as array instead of string
  servs+=("${servsinp[@]}")
    for svc in "${servs[@]}" ; do
        if [[ "$svc" == "ly" ]]; then
            sudo systemctl enable ly@tt1
        elif [[ "$svc" == "ufw" ]]; then
            sudo systemctl enable ufw --now
            sudo ufw default deny incoming
            sudo ufw default allow outgoing
            read -rp "${Yellow}Enable ssh through firewall? [y/N]${NC}" sshinp
            sshinp=${sshinp,,}
            sshinp=${sshinp:-N}
            case "$sshinp" in
              y) 
                sudo ufw allow ssh ;;
              n)
                 ;;
              *) 
                echo -e "${RED}Invalid option${NC}"
            esac
        else
            sudo systemctl enable "$svc" --now || {
                echo -e "${RED}Failed to enable $svc${NC}"
            }
        fi
    done
    
}

bootloader() {
    read -ep "$(echo -e "${GREEN}Bootloader (refind/grub) [refind]: ${NC}")" b
    b=${b:-refind}
    case "$b" in 
      g|grub)
          sudo pacman -S grub --needed --noconfirm 
          sudo bash "$user_home/.local/bin/grub_install" ;;
      r|refind) 
          sudo pacman -S refind --needed --noconfirm 
          sudo bash "$user_home/.local/bin/refind_install" ;;
      *) 
          echo -e "${RED}Invalid option!${NC}" ;;
    esac
} 

cursor() {
    dest="$user_home/.local/share/icons"
    mkdir -p "$dest"
    rm -rf "$dest/Anya-cursors"
    cp -r Anya-cursors "$dest"
}

ctrlcat0x() {
    sudo -u "$user" bash "$user_home/.local/bin/cursors.sh"
}

vpn() {
    sudo pacman -S wireguard-tools networkmanager --needed --noconfirm

    read -ep "$(echo -e "${GREEN}WireGuard config path: ${NC}")" cfg
    sudo cp "$cfg" /etc/wireguard/
    conf=$(basename "$cfg" .conf)

    sudo systemctl enable --now "wg-quick@$conf.service"
    nmcli connection import type wireguard file "/etc/wireguard/$conf.conf"
}

# =====================================================
# ================= UNINSTALL FUNCTIONS ================
# =====================================================

unstow() {
    cd "$user_home/hyprfiles" || exit 1
    stow -D sys hypr fastfetch swappy fish kitty matugen DankMaterualShell nvim rofi noctalia
}

unpkg() {
    sudo pacman -Rns --noconfirm \
        $(cat "$user_home/.local/bin/package-install" \
        | grep pacman | sed 's/.*-S //')
}

unbootloader() {
    echo -e "${YELLOW}Bootloader removal must be done manually.${NC}"
}

uncursor() {
    rm -rf "$user_home/.local/share/icons/Anya-cursors"
}

unctrlcat0x() {
    rm -rf /usr/share/icons/*ctrlcat*
}

unvpn() {
    sudo systemctl disable wg-quick@*.service || true
    sudo rm -rf /etc/wireguard
    nmcli connection delete type wireguard || true
}

# =====================================================
# ================= MENU HANDLERS =====================
# =====================================================

install_menu() {
    echo -e "${GREEN}
1) Stow dotfiles + system update
2) Install all packages
3) Enable services
4) Install Anya cursor
5) Install ctrlcat0x cursors
6) Full install (all)
7) WireGuard VPN
8) Install/Change Bootloader
9) Exit
${NC}"
    read -rp "Select option: " c

    case "$c" in
        1) stowupdate ;;
        2) pkg ;;
        3) enable_services ;;
        4) cursor ;;
        5) ctrlcat0x ;;
        6) stowupdate; pkg; bootloader; enable_services; cursor ;;
        7) vpn ;;
        8) bootloader;;
        9) exit 0 ;;
        *) echo -e "${RED}Invalid option${NC}" ;;
    esac
}

uninstall_menu() {
    echo -e "${RED}
1) Remove stowed dotfiles
2) Remove installed packages
3) Remove bootloader (manual)
4) Remove Anya cursor
5) Remove ctrlcat0x cursors
6) Remove WireGuard VPN
7) Exit
${NC}"
    read -rp "Select option: " c

    case "$c" in
        1) unstow ;;
        2) unpkg ;;
        3) unbootloader ;;
        4) uncursor ;;
        5) unctrlcat0x ;;
        6) unvpn ;;
        7) exit 0 ;;
        *) echo -e "${RED}Invalid option${NC}" ;;
    esac
}

# =====================================================
# ================= ENTRY =============================
# =====================================================

echo -e "${GREEN}
Choose mode:
1) Install
2) Uninstall
${NC}"

read -rp "Select: " mode

case "$mode" in
    1) install_menu ;;
    2) uninstall_menu ;;
    *) echo -e "${RED}Invalid selection${NC}" ;;
esac
