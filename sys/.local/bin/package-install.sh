#! /bin/bash

if command -v sysupdate &> /dev/null ; then
	sysupdate 
else 
	sudo pacman -S git stow --noconfirm --needed
	git clone https://github.com/kazzu-to/hyprfiles
	cd hyprfiles
	stow sys 
	cd $HOME
	sysupdate
fi

packages=( adobe-source-han-sans-otc-fonts amd-ucode android-tools arc-gtk-theme asusctl base base-devel bc blueman brave-bin brightnessctl btrfs-progs cliphist dolphin dysk eclipse-java-bin efibootmgr fastfetch flatpak  glib2-devel grim grub gst-plugin-pipewire gtkmm3 gvfs-mtp gvfs-smb htop hypridle hyprland hyprlock intel-media-driver iwd jdk-openjdk kdeconnect kitty kvantum libpulse librewolf-bin libva-intel-driver linux linux-firmware ly man-db meson midnight-gtk-theme-git mpc mpd nano nemo neovim nerd-fonts-noto-sans-mono net-tools network-manager-applet networkmanager noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra nwg-look openrazer-daemon os-prober otf-font-awesome pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse polkit-kde-agent python-pywal16 qt5-wayland qt5ct qt6-wayland qt6ct rofi-wayland rog-control-center sbctl scdoc shim-signed slurp smartmontools sof-firmware  swappy swaync swww sxiv tokyonight-gtk-theme-git tree ufw usbutils vesktop-bin vim vulkan-intel vulkan-radeon waybar wget wine-mono wireless_tools wireplumber wofi xdg-desktop-portal-hyprland xdg-user-dirs xdg-user-dirs-gtk xdg-utils xf86-video-amdgpu xf86-video-ati xf86-video-nouveau xf86-video-vmware xorg-server xorg-xinit  zram-generator )

for item in "${packages[@]}" ; do
	sudo pacman -S $item --noconfirm --needed
	if [[ $? -ne 0 ]]; then 
		echo "1" | yay $item --noconfirm --needed 
	fi
done 

