echo '########################################'
echo '###### Advanced Power Management #######'
echo '########################################'
for i in /dev/sd?; do
	sudo hdparm -B $i
done

echo '########################################'
echo '###### Standby Spindown Value ##########'
echo '########################################'
for i in /dev/sd?; do
	echo $i
	sudo hdparm -S $i
done

echo '########################################'
echo '#### Automatic Acoustic Management #####'
echo '########################################'
for i in /dev/sd?; do
	echo $i
	sudo hdparm -M $i
done

echo '########################################'
echo '###### Currently in Standby Mode? ######'
echo '########################################'
for i in /dev/sd?; do
	echo $i
	sudo smartctl -i -n standby $i
done
