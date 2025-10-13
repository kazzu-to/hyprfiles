
#!/usr/bin/env bash

# Try reading kernel LED state (if available)
for d in /sys/class/leds/*capslock*; do
    if [ -e "$d/brightness" ]; then
        value=$(cat "$d/brightness")
        if [ "$value" = "1" ]; then
            echo "CAPSLOCK ON"
        fi
        exit 0
    fi
done

# Fallback: try xset
state=$(xset q 2>/dev/null | awk -F: '/Caps Lock/ {print $2}' | awk '{print $1}')
if [ "$state" = "on" ]; then
    echo "CAPSLOCK ON"
fi
