#!/bin/bash

# Start mysql server
/etc/init.d/mysql restart

# Initialize default tables from $SITE_DIR/opsweekly.sql
mysql -e "create database opsweekly;"
mysql -e "grant all on opsweekly.* to $MYSQL_USER_NAME@localhost IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -u $MYSQL_USER_NAME --password=$MYSQL_PASSWORD opsweekly < /home/opsweekly/opsweekly.sql

# Test if the server configurations are correct
source /home/envvars && /usr/sbin/apache2 -t || { echo "Error in Apache configuration."; exit 1; }

# Start the Apache server at end
source /home/envvars && /usr/sbin/apache2 -DFOREGROUND &