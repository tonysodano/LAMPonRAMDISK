#!/bin/bash

################################################
# script1.sh                                   #
# LAMP ON RAMDISK                              #
# Author: Tony Sodano (me@tonysodano.com)      #
################################################

# Create ramdisk mount
/bin/mount -t tmpfs -o rw,size=${RAMDISKMBSIZE} tmpfs ${RAMDISKMOUNTPATH}


# Create apache directory
/bin/mkdir ${RAMDISKMOUNTPATHAPACHE}

# Create www root directory
/bin/mkdir ${RAMDISKMOUNTPATHWWW}

# Set apache permissions to ramdisk
/bin/chown -R $APACHEUSER:$APACHEUSERGROUP ${RAMDISKMOUNTPATHAPACHE}
/bin/chown -R $APACHEUSER:$APACHEUSERGROUP ${RAMDISKMOUNTPATHWWW}

# Create etc directory and set permissions
/bin/mkdir ${RAMDISKMOUNTPATHETC}

# Create logs directory and set permissions
/bin/mkdir ${RAMDISKMOUNTPATHLOGS}
/bin/chmod 755 ${RAMDISKMOUNTPATHLOGS}


# Create mysql directory and set permissions
/bin/mkdir ${RAMDISKMOUNTPATHMYSQL}
/bin/mkdir ${RAMDISKMOUNTPATHMYSQLDATA}
/bin/chown -R ${MYSQLUSER}:${MYSQLUSERGROUP} ${RAMDISKMOUNTPATHMYSQL}


# Create php directory
/bin/mkdir ${RAMDISKMOUNTPATHPHP}

