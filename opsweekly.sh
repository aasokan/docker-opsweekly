#!/bin/bash

# Start mysql server

# Initialize default tables from $SITE_DIR/opsweekly.sql
mysql < /home/setup.sql
mysql -u opsweekly_user opsweekly < /home/opsweekly/opsweekly.sql

# Test if the server configurations are correct
source /home/envvars && /usr/sbin/apache2 -t || { echo "Error in Apache configuration."; exit 1; }

# Start the Apache server at end
source /home/envvars && /usr/sbin/apache2 -DFOREGROUND