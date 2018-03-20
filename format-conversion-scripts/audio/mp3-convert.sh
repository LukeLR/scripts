#!/bin/bash
#First Argument: Old File ending
#Second Argument: File name
ffmpeg -i "$2" -codec:a libmp3lame -q:a 0 "${1/%$1/mp3}";
