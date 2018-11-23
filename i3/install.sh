#!/bin/bash
mkdir -p ~/.config/i3/
mkdir -p ~/.config/i3status/
cp i3_config ~/.config/i3/config
cp i3status_config ~/.config/i3status/config
cp wrapper.py ~/.config/i3status/wrapper.py
chmod a+x ~/.config/i3status/wrapper.py
