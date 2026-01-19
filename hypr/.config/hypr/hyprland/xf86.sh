#!/usr/bin/env bash
set -Eeuo pipefail

# ---------------- Colors ----------------
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
NC=$'\033[0m'
# ----------------------------------------

trap 'echo -e "\n${RED}Error on line $LINENO.${NC}"' ERR

KEYFILE="$HOME/.config/hypr/hyprland/keybind.conf"

rmkeys() {
  if [[ ! -f "$KEYFILE" ]]; then
    echo -e "${RED}No keybind.conf found in current directory.${NC}"
    exit 1
  fi

  sed -i '/XF86/Id' "$KEYFILE"
}

rmkeys

while true; do
  read -rp "$(echo -e "${GREEN}Choose keybind profile (default | dms-shell | noctalia-shell): ${NC}")" profile

  case "$profile" in
    default)
      deps=(brightnessctl pavucontrol kalk)

      for dep in "${deps[@]}"; do
        sudo pacman -S --needed --noconfirm "$dep"
      done

      cat >> "$KEYFILE" <<'EOF'

#----------------xf86-keys & firmware-controlled keys ------------------------------
binde = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
binde = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
binde = , XF86AudioPlay, exec, mpc toggle
binde = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle
binde = , XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle
binde = , XF86MonBrightnessDown, exec, brightnessctl s 10%-
binde = , XF86MonBrightnessUp, exec, brightnessctl s +10%
bind  = , XF86AudioStop, exec, pavucontrol
bind  = , XF86Calculator, exec, kalk
EOF
      break
      ;;

    dms-shell)
      echo -e "${GREEN}Using Dank Material Shell keybinds.${NC}"

      cat >> "$KEYFILE" <<'EOF'

#----------------xf86-keys & firmware-controlled keys - dms-controlled ------------------------------
bindl  = , XF86AudioPlay, exec, dms ipc call mpris playPause
bindl  = , XF86AudioNext, exec, dms ipc call mpris next
bindl  = , XF86AudioPrev, exec, dms ipc call mpris previous
bindel = , XF86AudioRaiseVolume, exec, dms ipc call audio increment 3
bindel = , XF86AudioLowerVolume, exec, dms ipc call audio decrement 3
bindel = , XF86AudioMute, exec, dms ipc call audio mute
bindel = , XF86AudioMicMute, exec, dms ipc call audio micmute
bindel = , XF86MonBrightnessUp, exec, dms ipc call brightness increment 5
bindel = , XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5
bind   = , XF86AudioStop, exec, pavucontrol
bind   = , XF86Calculator, exec, kalk
EOF
      break
      ;;

    noctalia-shell)
      echo -e "${GREEN}Using Noctalia shell keybinds.${NC}"

      cat >> "$KEYFILE" <<'EOF'

#----------------xf86-keys & firmware-controlled keys - noctalia-controlled ------------------------------
bindel = , XF86AudioRaiseVolume, exec, qs -c noctalia-shell ipc call volume increase
bindel = , XF86AudioLowerVolume, exec, qs -c noctalia-shell ipc call volume decrease
bindl  = , XF86AudioMute, exec, qs -c noctalia-shell ipc call volume muteOutput
bindl  = , XF86AudioMicMute, exec, qs -c noctalia-shell ipc call volume muteInput
bindl  = , XF86AudioPlay, exec, qs -c noctalia-shell ipc call media playPause
bindl  = , XF86AudioNext, exec, qs -c noctalia-shell ipc call media next
bindl  = , XF86AudioPrev, exec, qs -c noctalia-shell ipc call media previous
bindel = , XF86MonBrightnessUp, exec, qs -c noctalia-shell ipc call brightness increase
bindel = , XF86MonBrightnessDown, exec, qs -c noctalia-shell ipc call brightness decrease
bind   = , XF86AudioStop, exec, pavucontrol
bind   = , XF86Calculator, exec, kalk
EOF
      break
      ;;

    *)
      echo -e "${RED}Invalid option. Please choose one of:${NC}"
      echo "  default | dms-shell | noctalia-shell"
      ;;
  esac
done

echo -e "${GREEN}XF86 keybinds successfully configured.${NC}"
