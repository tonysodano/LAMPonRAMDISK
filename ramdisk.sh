#!/bin/sh -e
#######################################################
# ramdisk.sh                                          #
# LAMP ON RAMDISK                                     #
# Author: Tony Sodano (me@tonysodano.com)             #
#######################################################
# INSTALLATION INSTRUCTIONS:                          #
# 1: Download latest Apache, mySQL, PHP sources       #  
# 2: Create SOURCEDIR folder (mkdir <SOURCEDIR>)      #
# 3: Extract Apache to <SOURCEDIR>/apache-sources/    #
# 4: Extract mySQL to <SOURCEDIR>/mysql-source/       #
# 5: Extract PHP to <SOURCEDIR>/php/                  #
# 6: Place ramdisk scripts in <SOURCEDIR>/scripts     #
# 7: Set NEWINSTALL=1 below                           #
# 8: run ./ramdisk.sh                                 #
# 9: Set NEWINSTALL=0                                 #
# 10: Create BACKUPDIR folder (mkdir <BACKUPDIR>)     #
# 11: Create crontab entry for backups:               #
#     * 2 * * * SOURCEDIR/scripts/ramdisk.sh  backup  #
#######################################################

### BEGIN INIT INFO
# Provides:          ramdisk
# Required-Start:    checkroot
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: lamp on ramdisk 
# Description:       start/stop lamp on ramdisk
#                    
#To Update the init table and add the LSB: update-rc.d ramdisk defaults
### END INIT INFO

# Begin Configuration

# fresh operating system (first time running script2.sh) | 1 = yes / 0 = no 
export NEWINSTALL="0"
# source file directory
export SOURCEDIR="/sourcefiles/"
# backup folder
export BACKUPDIR="/backups/"
# ramdisk memory size in MB
export RAMDISKMBSIZE="512M"
# apache user
export APACHEUSER="nobody"
# apache group
export APACHEUSERGROUP="nobody"
# mysql user
export MYSQLUSER="mysql"
# mysql group
export MYSQLUSERGROUP="mysql"
# ramdisk directory
export RAMDISKMOUNTPATH="/chroot-ramdisk/"
# ramdisk apache directory
export RAMDISKMOUNTPATHAPACHE="/${RAMDISKMOUNTPATH}/apache/"
# ramdisk www root directory
export RAMDISKMOUNTPATHWWW="/${RAMDISKMOUNTPATH}/www/"
# ramdisk php directory
export RAMDISKMOUNTPATHPHP="/${RAMDISKMOUNTPATH}/php/"
# ramdisk mysql directory
export RAMDISKMOUNTPATHMYSQL="/${RAMDISKMOUNTPATH}/mysql/"
# ramdisk mysql data directory
export RAMDISKMOUNTPATHMYSQLDATA="/${RAMDISKMOUNTPATHMYSQL}/data/"
# ramdisk etc directory
export RAMDISKMOUNTPATHETC="/${RAMDISKMOUNTPATH}/etc/"
# ramdisk log directory
export RAMDISKMOUNTPATHLOGS="/${RAMDISKMOUNTPATH}/logs/"

# End Configuration 





case "$1" in

backup)

${SOURCEDIR}scripts/script3.sh


;;
start)

${SOURCEDIR}scripts/script1.sh
${SOURCEDIR}scripts/script2.sh

;;

stop)
killall -9 mysqld
killall -9 httpd
umount ${RAMDISKMOUNTPATH}
;;

reload|restart|force-reload)
killall -9 mysqld
killall -9 httpd
umount ${RAMDISKMOUNTPATH}
${SOURCEDIR}scripts/script1.sh
${SOURCEDIR}scripts/script2.sh

;;

*)

echo "Usage: [this] {start|stop|restart|reload|force-reload|backup}" >&2

exit 1

;;

esac

exit 0