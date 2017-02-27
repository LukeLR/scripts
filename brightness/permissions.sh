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

# This small script makes sure, that the user has write permissions #
# on the current brightness file, so that imac-increase-brightness  #
# and imac-decrease-brightness can actually change the value. Since #
# the permissions of these file are reset each reboot, it needs to  #
# be run once after each boot. Consider cron or runwhen.            #

# where all the files are located
base_path=/sys/class/backlight/acpi_video0/

# the name of the file where the current brightness is saved in
current_file=brightness

chmod a+w $base_path/$current_file
