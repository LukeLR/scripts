#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This script is a simple wrapper which prefixes each i3status line with custom
# information. It is a python reimplementation of:
# http://code.stapelberg.de/git/i3status/tree/contrib/wrapper.pl
#
# To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.py
# In the 'bar' section.
#
# In its current version it will display the cpu frequency governor, but you
# are free to change it to display whatever you like, see the comment in the
# source code below.
#
# © 2012 Valentin Haenel <valentin.haenel@gmx.de>
#
# This program is free software. It comes without any warranty, to the extent
# permitted by applicable law. You can redistribute it and/or modify it under
# the terms of the Do What The Fuck You Want To Public License (WTFPL), Version
# 2, as published by Sam Hocevar. See http://sam.zoy.org/wtfpl/COPYING for more
# details.

import sys
import json
import psutil

# extended from https://stackoverflow.com/a/1094933 (https://stackoverflow.com/questions/1094841/reusable-library-to-get-human-readable-version-of-file-size#1094933)
def sizeof_fmt(num, base=1024, suffix='B'):
    if (base == 1024):
        suffix = 'i' + suffix
    for unit in ['','K','M','G','T','P','E','Z']:
        if abs(num) < base:
            return "%3.1f%s%s" % (num, unit, suffix)
        num /= base
    return "%.1f%s%s" % (num, 'Y', suffix)

def get_governor():
    """ Get the current governor for cpu0, assuming all CPUs use the same. """
    with open('/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor') as fp:
        return fp.readlines()[0].strip()

def get_memory():
    """ Get statistics on memory usage """
    memory_used = sizeof_fmt(psutil.virtual_memory().used)
    memory_available = sizeof_fmt(psutil.virtual_memory().available)
    memory_free = sizeof_fmt(psutil.virtual_memory().free)
    memory_cached = sizeof_fmt(psutil.virtual_memory().cached)
    #memory_buffers = sizeof_fmt(psutil.virtual_memory().buffers)
    return (memory_used, memory_available, memory_free, memory_cached)

def get_fan_speed():
    """ Get the fan speed for fan0 """
    with open('/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon2/fan1_input') as fp:
        return fp.readlines()[0].strip()

def get_cpu_frequency():
    """ Get the cpu frequency for cpu0 """
    with open('/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq') as fp:
        return int(fp.readlines()[0].strip()) * 1000 # convert KHz unit to Hz

def get_brightness():
    with open('/sys/class/backlight/intel_backlight/brightness') as current_brightness_file, open('/sys/class/backlight/intel_backlight/max_brightness') as max_brightness_file:
        current_brightness = int(current_brightness_file.readlines()[0].strip())
        max_brightness = int(max_brightness_file.readlines()[0].strip())
        return current_brightness / max_brightness * 100

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()

def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()

if __name__ == '__main__':
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ''
        # ignore comma at start of lines
        if line.startswith(','):
            line, prefix = line[1:], ','

        j = json.loads(line)
        # insert information into the start of the json, but could be anywhere
        # CHANGE THIS LINE TO INSERT SOMETHING ELSE
        #j.insert(8, {'full_text' : '%s' % get_governor(), 'name' : 'gov'})
        j.insert(7, {'full_text' : '%s' % sizeof_fmt(get_cpu_frequency(),base=1000,suffix='Hz'), 'name' : 'cpu_frequency'})
        j.insert(8, {'full_text' : '%s RPM' % get_fan_speed(), 'name' : 'fan_speed'})
        j.insert(9, {'full_text' : 'Mu: %s a: %s f: %s c: %s' % get_memory(), 'name' : 'mem'})
        j.insert(10, {'full_text' : 'Bg: %.0f%%' % get_brightness(), 'name' : 'brightness'})
        # and echo back new encoded json
        print_line(prefix+json.dumps(j))
