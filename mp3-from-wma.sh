#!/bin/bash
ffmpeg -i "$1" -codec:a libmp3lame -q:a 0 "${1/%wma/mp3}";
