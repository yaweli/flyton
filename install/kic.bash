#!/bin/bash
#
# Flyton default admin script 
# Install :
#   link this script to /usr/bin/kic - then run it bu "kic" from everwhere in the terminal
#   chmod 755 file   - so it will be executable 
#   as root , let everone view the file /var/log/apache2/error.log
#
#######################


export ver=1.01
export db_name=my_name
export user=$USER
export host=`hostname`

echo "Welcome to $db_name $ver"
echo "==================================="
echo "s - mysql"
echo "l - tail error log"
echo "Options: "

if [ "x$1" = "x" ]
then read x
else x=$1
fi

if [ "x$x" = "xs" ]
then export MYSQL_PS1="$db_name> "
     mysql --user $db_name -p $db_name
fi

if [ "x$x" = "xl" ]
then tail -f /var/log/apache2/error.log
fi