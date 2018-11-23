#!/bin/bash
output="$(date "+%Y-%m-%d %H:%m:%S") Devices in standby: "

for i in /dev/sd?; do
	echo $i
	sudo smartctl -i -n standby $i|grep "Device is in STANDBY mode"
	if [ $? -eq 0 ]; then
		output="$output $i,"
	fi
done

echo $output
