#!/bin/bash
# LukeLR's backup script.
# Dependencies:
#  - rsync
#  - df
#  - hard links
#  - grep
#  - cut
#  - du
#  - df
#  - awk

echo "=================================="
echo "Welcome to LukeLR's backup script!"
echo "=================================="
echo

if [ $# -ne 2 ]; then
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
DEST=$2
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
SOURCESEPARATOR="" # Separator between credentials and path on source server

DESTCREDS="" # Credentials for destination server
DESTPATH="" # Path on destination server
DESTSEPARATOR="" # Separator between credentials and path on destination server

checksource() {
    if isremote $SOURCE; then
        echo "Source $SOURCE is remote!"
        SOURCEREMOTE=1
        SOURCESEPARATOR=:
        getcreds SOURCECREDS $SOURCE
        getpath SOURCEPATH $SOURCE
        SOURCESIZE=$(ssh $SOURCECREDS du -s $SOURCEPATH|cut -d$'\t' -f 1)
        echo "Size of $SOURCE: ${SOURCESIZE}K"
    else
        echo "Source $SOURCE is local!"
        SOURCEREMOTE=0
        SOURCESEPARATOR=
        SOURCECREDS=
        SOURCEPATH=$SOURCE
        SOURCESIZE=$(du -s $SOURCEPATH|cut -d$'\t' -f 1)
        echo "Size of $SOURCE: ${SOURCESIZE}K"
    fi
}

checkdestination() {
    if isremote $DEST; then
        echo "Destination $DEST is remote!"
        DESTREMOTE=1
        DESTSEPARATOR=:
        getcreds DESTCREDS $DEST
        getpath DESTPATH $DEST
        DESTAVAIL=$(ssh $DESTCREDS "df --output='avail' $DESTPATH"|cut -d$'\n' -f 2)
        echo "Free Space available at $DEST: ${DESTAVAIL}K"
    else
        echo "Destination $DEST is local!"
        DESTREMOTE=0
        DESTSEPARATOR=
        DESTCREDS=
        DESTPATH=$DEST
        DESTAVAIL=$(df --output="avail" $DESTPATH|cut -d$'\n' -f 2)
        echo "Free Space available at $DEST: ${DESTAVAIL}K"
    fi
}

checksource
checkdestination

echo Starting copying files from $SOURCEPATH on $SOURCECREDS to $DESTPATH on $DESTCREDS...

NUMBEROFTRIES=0 # How often rsync has failed already
MAXNUMBEROFTRIES=10 # How often to try to copy

deleteoldestbackup(){
    if [ $DESTREMOTE -eq 1 ]; then
        OLDESTBACKUP=$(ssh $DESTCREDS "ls -l $DESTPATH" | awk '{print $9}' | head -n 2 | tail -n 1)
    else
        OLDESTBACKUP=$(ls -l $DESTPATH | awk '{print $9}' | head -n 2 | tail -n 1)
    fi
    echo Oldest backup on $DEST is $OLDESTBACKUP. Deleting...

    if [ $DESTREMOTE -eq 1 ]; then
        ssh $DESTCREDS "rm -rf $DESTPATH/$OLDESTBACKUP"
    else
        rm -rf $DESTPATH/$OLDESTBACKUP
    fi
}

copyfiles(){
    rsync -aPe ssh $SOURCECREDS$SOURCESEPARATOR$SOURCEPATH $DESTCREDS$DESTSEPARATOR$DESTPATH/current/
    RSYNCEXIT=$?
    echo Rsync process exited with exit code $RSYNCEXIT.

    if [ $RSYNCEXIT -eq 11 ]; then # For example no free disk space
        NUMBEROFTRIES=$(($NUMBEROFTRIES + 1))
        if [ $NUMBEROFTRIES -lt $MAXNUMBEROFTRIES ]; then
            echo Retry backup no. $NUMBEROFTRIES
            deleteoldestbackup
            copyfiles
        else
            echo "Maximum number of tries reached ($MAXNUMBEROFTRIES). Aborting!"
            exit 1
        fi
    fi
}

copyfiles

DATE=$(date +%Y-%m-%d_%H-%M-%S)

echo Hardlinking current backup to $DATE...
if [ $DESTREMOTE -eq 1 ]; then
    ssh $DESTCREDS "cp -alf $DESTPATH/current $DESTPATH/$DATE"
else
    cp -alf $DESTPATH/current $DESTPATH/$DATE
fi
exit 0
