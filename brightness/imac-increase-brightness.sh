#!/bin/bash

# This file is part of LukeLR/scripts.
#
# LukeLR/scripts is free software: you can redistribute it and/or
# modify it under the terms of the cc-by-nc-sa (Creative Commons
# Attribution-NonCommercial-ShareAlike) as released by the
# Creative Commons organisation, version 3.0.
#
# LukeLR/scripts is distributed in the hope that it will be useful,
# but without any warranty.
#
# You should have received a copy of the cc-by-nc-sa-license along
# with this copy of LukeLR/scripts. If not, see
# <https://creativecommons.org/licenses/by-nc-sa/3.0/legalcode>.
#
# Copyright Lukas Rose 2017, public [at] lrose [dot] de

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
