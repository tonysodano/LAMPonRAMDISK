#!/bin/bash
################################################
#                                              #
# Backup Rotation Script for LAMP ON RAMDISK   #
# Author: Tony Sodano (me@tonysodano.com)      #
#                                              #
################################################

# What will be saved? 
BACKUPDIR="/etc ${SOURCEDIR}config  ${SOURCEDIR}database  ${SOURCEDIR}etc  ${SOURCEDIR}mysql  ${SOURCEDIR}scripts  ${SOURCEDIR}www"

# Backup destination path.
DESTINATIONDIR=${BACKUPDIR}

# Variable for the Backupfilename
DAYCOUNT=$(date +%A)
SERVERNAME=$(hostname)

# What week is it (1-4)
DAYCOUNT_NUM=$(date +%d)
if (( $DAYCOUNT_NUM <= 7 )); then
        WEEK_FILE="$SERVERNAME-week1.tgz"
elif (( $DAYCOUNT_NUM > 7 && $DAYCOUNT_NUM <= 14 )); then
        WEEK_FILE="$SERVERNAME-week2.tgz"
elif (( $DAYCOUNT_NUM > 14 && $DAYCOUNT_NUM <= 21 )); then
        WEEK_FILE="$SERVERNAME-week3.tgz"
elif (( $DAYCOUNT_NUM > 21 && $DAYCOUNT_NUM < 32 )); then
        WEEK_FILE="$SERVERNAME-week4.tgz"
fi

# Two Month Backup.
MONTH_NUMBER=$(date +%m)
MONTH=$(expr $MONTH_NUMBER % 2)
if [ $MONTH_NUMBER == 1 ]; then
        MONTH_FILE="$SERVERNAME-MONTH1.tgz"
elif [ $MONTH_NUMBER == 2 ]; then
        MONTH_FILE="$SERVERNAME-MONTH2.tgz"
elif [ $MONTH_NUMBER == 3 ]; then
        MONTH_FILE="$SERVERNAME-MONTH3.tgz"
elif [ $MONTH_NUMBER == 4 ]; then
        MONTH_FILE="$SERVERNAME-MONTH4.tgz"
elif [ $MONTH_NUMBER == 5 ]; then
        MONTH_FILE="$SERVERNAME-MONTH5.tgz"
elif [ $MONTH_NUMBER == 6 ]; then
        MONTH_FILE="$SERVERNAME-MONTH6.tgz"
elif [ $MONTH_NUMBER == 7 ]; then
        MONTH_FILE="$SERVERNAME-MONTH7.tgz"
elif [ $MONTH_NUMBER == 8 ]; then
        MONTH_FILE="$SERVERNAME-MONTH8.tgz"
elif [ $MONTH_NUMBER == 9 ]; then
        MONTH_FILE="$SERVERNAME-MONTH9.tgz"
elif [ $MONTH_NUMBER == 10 ]; then
        MONTH_FILE="$SERVERNAME-MONTH10.tgz"
elif [ $MONTH_NUMBER == 11 ]; then
        MONTH_FILE="$SERVERNAME-MONTH11.tgz"
else 
        MONTH_FILE="$SERVERNAME-MONTH12.tgz"
fi

# Archivename.
if [ $DAYCOUNT_NUM == 1 ]; then
        ARCHIVE_FILE=$MONTH_FILE
elif [ $DAYCOUNT != "SaturDAYCOUNT" ]; then
        ARCHIVE_FILE="$SERVERNAME-$DAYCOUNT.tgz"
else 
        ARCHIVE_FILE=$WEEK_FILE
fi

# Status Message.
echo "Backup $BACKUPDIR to $DESTINATIONDIR/$ARCHIVE_FILE"
date
echo

# Save the file with a Tar.
tar czPf $DESTINATIONDIR/$ARCHIVE_FILE $BACKUPDIR

# End Status Message.
echo
echo "Backup success"
date

#long list in the $DESTINATIONDIR to control file size.
ls -lh $DESTINATIONDIR/
