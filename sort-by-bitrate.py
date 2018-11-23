#!/bin/python
import sys
import os,subprocess

files = {}

for file in sys.argv[1:]:
    filesize = os.path.getsize(file)*8 # File size in bit
    duration = float(subprocess.Popen(['ffprobe', '-v', 'error', '-show_entries',
        'format=duration', '-of', 'default=noprint_wrappers=1:nokey=1', file],
        stdout=subprocess.PIPE).stdout.read().decode("utf-8").rstrip())
        # duration in seconds, decoded as utf-8 and newline removed and converted to float
    bitrate = filesize / duration
    files[file] = bitrate
    
print(files)

def getKey(item):
    return float(item[1]) # Sort after bitrate which is the second entry

sorted_files = sorted(files.items(), key=getKey)

# https://stackoverflow.com/a/1094933 (https://stackoverflow.com/questions/1094841/reusable-library-to-get-human-readable-version-of-file-size#1094933)
def sizeof_fmt(num, suffix='B'):
    for unit in ['','Ki','Mi','Gi','Ti','Pi','Ei','Zi']:
        if abs(num) < 1024.0:
            return "%3.1f%s%s" % (num, unit, suffix)
        num /= 1024.0
    return "%.1f%s%s" % (num, 'Yi', suffix)

print(sorted_files)
for x in sorted_files:
    print("Bit rate: {:>20} file: {}".format(sizeof_fmt(x[1], suffix='Bit/s'), x[0]))

