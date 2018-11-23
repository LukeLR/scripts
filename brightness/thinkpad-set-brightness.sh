#!/bin/bash
BACKLIGHT_FILE="/sys/class/backlight/intel_backlight/brightness"
old=$(/usr/bin/cat "$BACKLIGHT_FILE")
echo "Changing brightness from $old to $1..."
echo "$1" > "$BACKLIGHT_FILE"
