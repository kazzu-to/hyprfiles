#!/usr/bin/env bash
set -e

sudo pacman -S --needed unzip git

TMPDIR="/tmp/cursors"
rm -rf "$TMPDIR"
git clone https://github.com/ctrlcat0x/cursors.git "$TMPDIR"

cursor1="$TMPDIR/cursor_pack_1"
cursor2="$TMPDIR/cursor_pack_2"

apply() {
    local folder="$1"
    for zipfile in "$folder"/*.zip; do
        [ -f "$zipfile" ] || continue
        echo "Installing cursor pack: $zipfile"
        sudo unzip -o "$zipfile" -d /usr/share/icons/
    done
}

apply "$cursor1"
apply "$cursor2"

echo "✅ All cursor packs installed to /usr/share/icons/"
