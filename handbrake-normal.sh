#!/bin/bash

oldfilename=$1
extension=${oldfilename##*.}
echo Extension: $extension
newfilename=${1/%$extension/mp4}

if [[ ! $1 ]]
then
	echo "Converts any media to H.264 MP4 using handbrake CLI and normal profile."
	echo -e "Usage:\n\t$0 'file name'"
	exit 1
fi

if [ -f "$newfilename" ]
then
	echo "File $newfilename already exists. Skipping..."
	echo "$newfilename" >> skipped_files.txt
else
	echo Converting $oldfilename to $newfilename ...
	handbrakecli -Z Legacy/Normal -i $oldfilename -o $newfilename
fi
