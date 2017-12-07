#!/bin/bash
PATH="/sys/class/backlight/intel_backlight/brightness"
old=$(/usr/bin/cat "$PATH")
echo "Changing brightness from $old to $1..."
echo "$1" | /usr/bin/sudo /usr/bin/tee "$PATH"
