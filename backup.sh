#!/bin/bash
# LukeLR's backup script.
# Dependencies:
#     - rsync
#     - df
#     - hard links
#     - grep
#     - cut
#     - du
#     - df

set -e
#set -x
set -o pipefail

echo "=================================="
echo "Welcome to LukeLR's backup script!"
echo "=================================="
echo

if [ $# -ne 2 ] then
    echo "Illegal number of parameters. Needs 2 parameters:"
    echo "backup.sh SOURCE DESTINATION"
    echo
    echo "Parameters:"
    echo "    SOURCE     : Source folder to back up"
    echo "    DESTINATION: Backup folder on the destination volume"
    echo
    echo "Format:"
    echo "    SOURCE and DESTINATION can be one of the following:"
    echo "        - user@server:path (for rsync / ssh access)"
    echo "        - path (for local folders)"
    echo "Exiting."
    exit 1
fi

echo "Preparing... Checking for free space... "

SOURCE=$1
VOLUME=$2
DEST=$3
LOGFOLDER=$HOME/log/backup/

checklogfolder() {
    if [ ! -d $LOGFOLDER ]; then
        echo Creating log folder $LOGFOLDER
        mkdir -p $LOGFOLDER
    fi
}

isremote() {
    if [[ $1 =~ ^.+@.+:.+ ]]; then
        return 0
    else
        return 1
    fi
}

# Usage: getuser returnvar $source; echo $returnvar
function getuser() {
    eval "$1=$(echo $2 | cut -d@ -f 1)"
}

function gethost() {
    eval "$1=$(echo $2 | cut -d@ -f 2 | cut -d: -f 1)"
}

function getpath() {
    eval "$1=$(echo $2 | cut -d: -f 2)"
}

function getcreds() {
    eval "$1=$(echo $2 | cut -d: -f 1)"
}

SOURCEREMOTE=-1 # If SOURCE is on remote server
DESTREMOTE=-1 # If DESTINATION is on remote server

SOURCECREDS="" # Credentials for source server
SOURCEPATH="" # Path on source server

DESTCREDS="" # Credentials for destination server
DESTPATH="" # Path on destination server

checksource() {
    if isremote $SOURCE; then
        echo "$SOURCE is remote!"
        SOURCEREMOTE=1
        getcreds SOURCECREDS $SOURCE
        getpath SOURCEPATH $SOURCE
        SOURCESIZE=$(ssh $SOURCECREDS du -s $SOURCEPATH|cut -d$'\t' -f 1)
        echo "Size of $SOURCE: ${SOURCESIZE}K"
    else
        echo "$SOURCE is local!"
        SOURCEREMOTE=0
        SOURCEPATH=$SOURCE
        SOURCESIZE=$(du -s $SOURCEPATH|cut -d$'\t' -f 1)
        echo "Size of $SOURCE: ${SOURCESIZE}K"
    fi
}

checkdestination() {
    if isremote $DEST; then
        echo "$DEST is remote!"
        DESTREMOTE=1
        getcreds DESTCREDS $DEST
        getpath DESTPATH $DEST
        DESTAVAIL=$(ssh $DESTCREDS "df --output='avail' $DESTPATH"|cut -d$'\n' -f 2)
        echo "Free Space available at $DEST: ${DESTAVAIL}K"
    else
        echo "$DEST is local!"
        DESTREMOTE=0
        DESTPATH=$DEST
        DESTAVAIL=$(df --output="avail" $DESTPATH|cut -d$'\n' -f 2)
        echo "Free Space available at $DEST: ${DESTAVAIL}K"
    fi
}

checkfreespace() {
    
}

DATE=$(date +%Y-%m-%d_%H-%M-%S)

#freespace=$(ssh $user@$server "df" | grep $volume | awk '{ print $4 }')
#freespace=0
maxspace=500000000

#Set to 0 to use traditional maxspace-method, 1 for modern at least as much free as occupied-method.
usemodernmethod=$false

deleteoldestbackup() {
    echo Backups:
    #ssh $user@$server ls $dest
#    oldestbackup=$(ssh $user@$server ls -l $dest | grep -v ^t | awk '{ print $9 }' | 
head -n 1)
    echo -ne "Oldest backup is $dest/$oldestbackup, removing..."
#    ssh $user@$server "sudo rm -rvf $dest/$oldestbackup" >> $logfolder/$oldestbackup-delete.log
#    ssh $user@$server "echo Banane" >> $logfolder/$oldestbackup-delete
    echo See $logfolder/$oldestbackup-delete.log for deletion logs.
0    echo 
}

i=0
if [ $freespace -lt $criticalspace ]; then
#    usedspace=$(ssh $user@$server "du -d 0 $dest"|awk '{ print $1 }')
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

#sudo rsync -ave ssh --stats --delete 
--exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","CloudStation","Dropbox"} / $user@$server:$dest/current >> $logfolder/$date-create.log

echo Making hardcopy to date folder...
#ssh $user@$server cp -alf $dest/current $dest/$date
echo "Done! Thanks for using this backup script. It was developed by lukas (public@lrose.de)!"
