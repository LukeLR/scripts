#!/bin/bash
set -e
set -o pipefail

echo "=================================="
echo "Welcome to LukeLR's backup script!"
echo "=================================="
echo

if [ $# -ne 3 ] then
    echo "Illegal number of parameters. Needs 3 parameters:"
    echo "backup.sh SOURCE VOLUME DESTINATION"
    echo
    echo "Parameters:"
    echo "    SOURCE     : Source folder to back up"
    echo "    VOLUME     : Name of the destination volume"
    echo "    DESTINATION: Backup folder on the destination volume"
    echo
    echo "Format:"
    echo "    SOURCE and DESTINATION can be one of the following:"
    echo "        - user@server:folder (for ssh access)"
    echo "        - folder (for local folders)"
    echo "Exiting."
    return 1
fi

echo "Preparing... Checking for free space... "

source=$1
volume=$2
dest=$3
logfolder=$HOME/log/backup/

checklogfolder() {
    if [ ! -d $logfolder ]; then
        echo Creating log folder $logfolder
        mkdir -p $logfolder
    fi
}

checksource() {
    
}

date=$(date +%Y-%m-%d_%H-%M-%S)



freespace=$(ssh $user@$server "df" | grep $volume | awk '{ print $4 }')
#freespace=0
maxspace=500000000

#Set to 0 to use traditional maxspace-method, 1 for modern at least as much free as occupied-method.
usemodernmethod=$false

deleteoldestbackup() {
    echo Backups:
    ssh $user@$server ls $dest
    oldestbackup=$(ssh $user@$server ls -l $dest | grep -v ^t | awk '{ print $9 }' | head -n 1)
    echo -ne "Oldest backup is $dest/$oldestbackup, removing..."
#    ssh $user@$server "sudo rm -rvf $dest/$oldestbackup" >> $logfolder/$oldestbackup-delete.log
    ssh $user@$server "echo Banane" >> $logfolder/$oldestbackup-delete
    echo See $logfolder/$oldestbackup-delete.log for deletion logs.
    echo 
}

i=0
if [ $freespace -lt $criticalspace ]; then
    usedspace=$(ssh $user@$server "du -d 0 $dest"|awk '{ print $1 }')
    #usedspace=9999999999
    if [ $usemodernmethod ]; then
        #It should be at least as much space free as the backup occupies
        echo "Using modern method to determine space limits..."
        echo
        while [ $freespace -lt $usedspace ] && [ $i -lt 50 ]; do
            echo Undershot minimum free space! It should be at least as much space free as the backup occupies!
            echo Free space available: $freespace KB.
            echo Backup occupies: $usedspace KB.
            echo Deleting oldest backup \#$i...
            deleteoldestbackup
            echo
            let i=i+1
       done
    else
        echo "Using traditional method to determine space limits..."
        echo
        while [ $usedspace -gt $maxspace ] && [ $i -lt 50 ]; do
            echo Exceeded maximum space!
            echo Free space available: $freespace KB.
            echo Backup occupies: $usedspace KB.
            echo Space limit is at $maxspace KB!
            echo Deleting oldest backup \#$i...
            deleteoldestbackup
            echo
            let i=i+1
       done
    fi
else
    echo "Free space is not below critical level:"
    echo "Free space: $freespace K."
    echo "Critical level: $criticalspace K."
    echo
fi

echo Enough free space!
echo Free space available: $freespace KB
echo Backup occupies: $usedspace KB

echo Updating current snapshot...
echo Will copy files now... See $logfolder/$date-create.log for rsync logs.

sudo rsync -ave ssh --stats --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","CloudStation","Dropbox"} / $user@$server:$dest/current >> $logfolder/$date-create.log

echo Making hardcopy to date folder...
ssh $user@$server cp -alf $dest/current $dest/$date
echo "Done! Thanks for using this backup script. It was developed by lukas (public@lrose.de)!"
