#!/usr/bin/env bash
set -e

command -v lspci >/dev/null || { echo "Install pciutils"; exit 1; }

if ! lspci | grep -iq nvidia; then
    echo "No NVIDIA GPU found. Exiting."
    exit 0
fi

echo "NVIDIA GPU detected."

nvidia_conf="/etc/modprobe.d/nvidia.conf"

configure_nvidia() {
    sudo mkdir -p /etc/modprobe.d

    sudo tee "$nvidia_conf" > /dev/null <<EOF
options nvidia NVreg_PreserveVideoMemoryAllocations=1
options nvidia NVreg_TemporaryFilePath=/var/tmp
EOF

    echo "NVIDIA config written to $nvidia_conf"
}

configure_nvidia
