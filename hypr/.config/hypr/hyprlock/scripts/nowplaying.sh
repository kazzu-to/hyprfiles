
#!/usr/bin/env bash
set -euo pipefail

TARGET="/tmp/albumart.png"
FALLBACK="$HOME/.config/hypr/hyprlock/icons/pasted-music.png"

# require playerctl
if ! command -v playerctl >/dev/null 2>&1; then
  echo "playerctl not found" >&2
  cp "$FALLBACK" "$TARGET"
  exit 1
fi

# find playing player's art URL
album_art_url=""
while IFS= read -r p; do
  [ -z "$p" ] && continue
  status="$(playerctl -p "$p" status 2>/dev/null || true)"
  if [[ "$status" == "Playing" ]]; then
    url="$(playerctl -p "$p" metadata --format '{{ mpris:artUrl }}' 2>/dev/null || true)"
    if [[ "$p" == "spotify" ]]; then
      url="$(echo "$url" | sed 's|https://open.spotify.com/image/|https://i.scdn.co/image/|')"
    fi
    album_art_url=${url#\"}
    album_art_url=${album_art_url%\"}
    break
  fi
done <<< "$(playerctl -l 2>/dev/null || true)"

# if no url, install fallback and exit
if [ -z "${album_art_url:-}" ]; then
  cp "$FALLBACK" "$TARGET"
  chmod 644 "$TARGET"
  exit 1
fi

# download to temp file
tmp_download="$(mktemp --suffix=.download)"
trap 'rm -f "$tmp_download" "$tmp_download.png" >/dev/null 2>&1' EXIT

if ! curl -fLsS --max-time 8 "$album_art_url" -o "$tmp_download"; then
  cp "$FALLBACK" "$TARGET"
  chmod 644 "$TARGET"
  exit 1
fi

# magick to PNG (requires ImageMagick convert); if convert missing, try fallback
if command -v magick >/dev/null 2>&1; then
  # write conversion output to a new temp file to keep atomicity
  magick "$tmp_download" "$tmp_download.png"
  mv -f "$tmp_download.png" "$TARGET"
else
  # no magick available — try to move downloaded file as-is (hyprlock may support it)
  mv -f "$tmp_download" "$TARGET"
fi

chmod 644 "$TARGET"
exit 0
