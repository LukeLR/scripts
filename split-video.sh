#!/bin/bash
file=$1            # File to split
split_length=$2    # Duration of each path in seconds
start=0            # Start of the encoding in seconds
stop=$split_length # Stop of the encoding in seconds
i=0                # Number of the current part
duration=$(($(mediainfo --Inform="General;%Duration%" "$1")/1000))

echo "Splitting file $file into parts with $split_length seconds each."
echo "File is $duration seconds long."

while [ $stop -lt $(($duration + $split_length)) ]; do
	echo "Part $i ranges from $start to $stop seconds."
	filename="${file%.*}_part$i.mp4"

	handbrakecli --input "$file" --output "$filename" --use-opencl --markers --optimize --encoder x264 --encoder-preset veryfast --encoder-level 4.0 --quality 20.0 --vfr --all-audio --aencoder copy:aac --audio-copy-mask aac --audio-fallback av_aac --aq 10 --all-subtitles --start-at duration:$start --stop-at duration:$split_length

	start=$(($start + $split_length))
	stop=$(($stop + $split_length))
	i=$(($i + 1))
done
