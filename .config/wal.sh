#!/bin/bash

# Define the wallpapers directory
WALLPAPERS_DIR=~/wallpapers

# Use feh to select an image and capture the output
IMAGE=$(feh --no-fehbg --no-menus --scale-down --action  "echo %f; killall feh" "$WALLPAPERS_DIR")

# Check if an image was selected
if [[ -n "$IMAGE" ]]; then
    # Set the selected image as wallpaper using swww
    swww img "$IMAGE"
    wal -i "$IMAGE"
    killall waybar && waybar
else
    echo "No image selected."
fi

