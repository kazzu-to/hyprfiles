
#!/usr/bin/env bash

# Check if upower is available
if ! command -v upower &> /dev/null; then
    echo "upower is not installed. Please install it first."
    exit 1
fi

# Get battery percentage and status (charging or discharging)
battery_info=$(upower -i $(upower -e | grep battery) | grep -E 'percentage|state')

# Extract percentage and state
battery_percentage=$(echo "$battery_info" | grep percentage | awk '{print $2}' | tr -d '%')
battery_state=$(echo "$battery_info" | grep state | awk '{print $2}')

# Determine the glyph based on battery percentage and state
if [[ "$battery_state" == "charging" ]]; then
    battery_glyph=" "  # Full battery glyph when charging
elif [[ "$battery_percentage" -ge 50 ]]; then
    battery_glyph=" " # Half battery glyph for 50% or above
elif [[ "$battery_percentage" -ge 20 ]]; then
    battery_glyph=" "  # Quarter battery glyph for below 50% but above 20%
else
    battery_glyph=" "  # Empty battery glyph for below 20%
fi

# Output the result: glyph and battery percentage
echo -e "$battery_glyph  $battery_percentage%"
