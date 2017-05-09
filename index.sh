#!/bin/bash
echo "Name;Genre;"
for i in *; do
	if [ -d "${i}" ]; then
		cd "${i}"
		for j in *; do
			echo "$j;$i;"
		done
		cd ..
	fi
done
