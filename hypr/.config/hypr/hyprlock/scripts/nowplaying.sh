
#!/usr/bin/env bash

# Check if playerctl is installed
if ! command -v playerctl &> /dev/null; then
    echo "playerctl is not installed. Please install it first."
    exit 1
fi

# Get the album art (cover image) URL using playerctl
album_art_url=$(playerctl metadata --format '{{ mpris:artUrl }}')

# Check if the album art URL is available
if [ -z "$album_art_url" ]; then
	cp $HOME/.config/hypr/hyprlock/icons/pasted-music.png /tmp/albumart.png
    echo "No media is currently playing or no album art is available."
    exit 1
fi

# Download the album art and store it in /tmp/albumart.png
curl -s "$album_art_url" -o /tmp/albumart.png

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "Album art saved to /tmp/albumart.png"
else
    echo "Failed to download album art."
    exit 1
fi
