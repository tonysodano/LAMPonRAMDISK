#!/bin/bash

################################################
# script2.sh                                   #
# LAMP ON RAMDISK                              #
# Author: Tony Sodano (me@tonysodano.com)      #
################################################



###########################################
# mySQL setup
###########################################

cd ${SOURCEDIR}mysql-source/

# Configure mySQL
if [ "${NEWINSTALL}" -eq 1 ] 
then 
	./configure --prefix=${RAMDISKMOUNTPATHMYSQL} --enable-assembler --with-extra-charsets=complex --enable-thread-safe-client --with-big-tables --with-readline --with-ssl --with-plugins=max-no-ndb --with-embedded-server --enable-local-infile --with-mysqld-user=${MYSQLUSER}
fi

# Compile mySQL
if [ "${NEWINSTALL}" -eq 1 ] 
then 
	make
fi

# Install mysql to ramdisk
make install

# Import / install database to ramdisk-mysql
if [ "${NEWINSTALL}" -eq 1 ] 
then
	# create generic database so mysql can start
	${RAMDISKMOUNTPATHMYSQL}bin/mysql_install_db --user=${MYSQLUSER} --basedir=${RAMDISKMOUNTPATHMYSQL} --datadir=${RAMDISKMOUNTPATHMYSQLDATA}
	/bin/cp -R ${SOURCEDIR}database/* ${RAMDISKMOUNTPATHMYSQLDATA}
else
	# Import existing databases
	/bin/cp -R ${SOURCEDIR}database/* ${RAMDISKMOUNTPATHMYSQLDATA}
fi

# Set user:group to ramdisk mySQL
/bin/chown -R ${MYSQLUSER}:${MYSQLUSERGROUP} ${RAMDISKMOUNTPATHMYSQL}





###########################################
# Apache setup
###########################################

# switch to Apache source dir
cd ${SOURCEDIR}apache-sources/


# Configure Apache
if [ "${NEWINSTALL}" -eq 1 ] 
then
	./configure --prefix=${RAMDISKMOUNTPATHAPACHE} --enable-mime-magic --enable-expires --enable-headers --enable-ssl --enable-http --enable-info --enable-dir --enable-rewrite --enable-so
fi

# Compile Apache
if [ "${NEWINSTALL}" -eq 1 ] 
then
	make
fi

# Install Apache to ramdisk
make install

# Copy over sourcefiles httpd.conf to ramdisk-apache
/bin/cp ${SOURCEDIR}config/apache/httpd.conf ${RAMDISKMOUNTPATHAPACHE}conf/





###########################################
# PHP setup
###########################################

# Switch to Apache source folder
cd ${SOURCEDIR}/php-source/

# Configure PHP
if [ "${NEWINSTALL}" -eq 1 ] 
then

	./configure --prefix=${RAMDISKMOUNTPATHPHP} --with-apxs2=${RAMDISKMOUNTPATHAPACHE}bin/apxs --with-mysql=shared,${RAMDISKMOUNTPATHMYSQL} --with-zlib --with-gettext --with-mysql=${RAMDISKMOUNTPATHMYSQL} --with-mysqli=${RAMDISKMOUNTPATHMYSQL}bin/mysql_config  --with-mysql-sock=${RAMDISKMOUNTPATHMYSQL}mysql.sock --with-sqlite 
fi

# Compile PHP
if [ "${NEWINSTALL}" -eq 1 ] 
then
	make
fi

# Install PHP on ramdisk
make install

# Copy sourcefiles php.ini to ramdisk-php
/bin/cp ${SOURCEDIR}config/php/php.ini ${RAMDISKMOUNTPATHPHP}/lib/php.ini




###########################################
# Start mySQL / Apache
###########################################
# Start mysql server off disk
${RAMDISKMOUNTPATHMYSQL}libexec/mysqld --basedir=${RAMDISKMOUNTPATHMYSQL} --datadir=${RAMDISKMOUNTPATHMYSQLDATA} --user=${MYSQLUSER} --log-error=${RAMDISKMOUNTPATHMYSQL}mysql.ramdisk.err --pid-file=${RAMDISKMOUNTPATHMYSQL}mysql.ramdisk.pid --port=3308 --socket=${RAMDISKMOUNTPATHMYSQL}mysql.sock >/dev/null &

# Start Apache
${RAMDISKMOUNTPATHAPACHE}bin/apachectl start