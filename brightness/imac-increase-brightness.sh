#!/bin/bash
# This simple bash script will read the current and the maximum    #
# brightness, calculate the step value for 10 steps of brightness, #
# increase the brightness by one step and write that value to the  #
# current brightness. This script is designed for use on my 27"    #
# iMac late 2012, but should work with most other laptops /        #
# all-in-one-desktops equally well.                                #

# where all the files are located
base_path=/sys/class/backlight/acpi_video0/

# the name of the file where the current brightness is saved in
current_file=brightness

# the name of the file where the maximum brightness is saved in
max_file=max_brightness

# read current value
current=$(cat $base_path$current_file)

# read max value
max=$(cat $base_path$max_file)

# echo both values
echo current value: $current of $max

# calculate step value
((step=max/10))

# echo step value
echo increasing brightness by $step ...

# calculate new value
((new=current+step))

# echo new value
echo setting new value: $new

echo $new > $base_path$current_file
