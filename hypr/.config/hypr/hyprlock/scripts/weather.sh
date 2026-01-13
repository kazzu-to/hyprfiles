#!/usr/bin/env bash
set -euo pipefail

dependencies=("jq" "ifconfig" "grep" "curl")

for item in "${dependencies[@]}" ; do 
  if ! command -v "$item" >/dev/null 2>&1; then
    echo "$item not found, please install first" >&2
  fi
done

external_ip=$(curl -s --max-time 10 ifconfig.me | grep -oE '(([0-9]{1,3}\.){3}[0-9]{1,3})|(([0-9a-fA-F]{1,4}:){1,7}[0-9a-fA-F]{1,4})')

if [[ -z "$external_ip" ]]; then
  echo "Could not determine external IP" >&2
  exit 1
fi

city=$(curl -s https://ipinfo.io/"$external_ip" | jq -r '.city' | awk -v OFS='+' '{$1=$1; print}')

if [[ -z "$city" ]]; then
  echo "Could not determine city for IP $external_ip" >&2
  exit 1
fi

curl -s wttr.in/"$city"?format=4
