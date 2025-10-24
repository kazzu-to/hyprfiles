
#!/bin/bash

# get player list (one per line)
players=$(playerctl -l 2>/dev/null)

# look for a player that is Playing
for p in $players; do
  status=$(playerctl -p "$p" status 2>/dev/null || echo "Unknown")
  if [[ $status == "Playing" ]]; then
    # change format as you like: '{{artist}} - {{title}}' or '{{title}}'
    song_info=$(playerctl -p "$p" metadata --format '{{artist}} - {{title}}' 2>/dev/null)
    echo "| $song_info"
    exit 0
  fi
done

# fallback: no player is playing — show the first player's info (or print a message)
first_player=$(echo "$players" | head -n1)
if [[ -n $first_player ]]; then
  status=$(playerctl -p "$first_player" status 2>/dev/null || echo "Unknown")
  song_info=$(playerctl -p "$first_player" metadata --format '{{artist}} - {{title}}' 2>/dev/null)
  echo "| $song_info (status: $status)"
else
  echo " "
fi
