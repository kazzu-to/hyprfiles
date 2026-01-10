#!/usr/bin/env bash

command -v lspci >/dev/null || { echo "Install pciutils"; exit 1; }

if lspci | grep -iq nvidia; then
    echo "NVIDIA GPU detected."
else
    echo "No NVIDIA GPU found."
fi

nvidia_conf="/etc/modprobe.d/nvidia.conf"

nvidia() {
    mkdir -p /etc/modprobe.d

    if [[ ! -f "$nvidia_conf" ]]; then
        touch "$nvidia_conf"
    fi

    # Write options to the config file
    cat > "$nvidia_conf" <<EOF
options nvidia NVreg_PreserveVideoMemoryAllocations=1
options nvidia NVreg_TemporaryFilePath=/var/tmp
EOF

    echo "NVIDIA config written to $nvidia_conf"
}

nvidia
