#!/bin/bash

# Start mysql server

# Test if the server configurations are correct
source /home/envvars && /usr/sbin/apache2 -t || { echo "Error in Apache configuration."; exit 1; }

# Start the Apache server at end
source /home/envvars && /usr/sbin/apache2 -DFOREGROUND