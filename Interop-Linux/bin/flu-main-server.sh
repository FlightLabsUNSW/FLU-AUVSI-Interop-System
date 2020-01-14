#!/bin/bash

# Interop server startup & setup script

# Determines the root directory
user=$(pwd)

# Find the root directory and change to the right directory
cd $user/interop/server

# Check for any user input on runnning the script	
if [[ $1 = "upgrade" ]]
then
        # Upgrade server data
        sudo ./interop-server.sh upgrade
        
elif [[ $1 = "remove" ]]
then
        # Remove server data
        sudo ./interop-server.sh rm_data
        
else
        # Turn the interop server on (can be found at http://localhost:8000 or http://youripaddress:8000)
        sudo ./interop-server.sh up
        
fi

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 14 January 2020
