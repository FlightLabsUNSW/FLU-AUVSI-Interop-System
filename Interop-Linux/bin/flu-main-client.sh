#!/bin/bash

# Script to start the interop client and start telemetry upload

# Determines the root directory
user=$(pwd)

# Include functions and information from other scripts
source $user/bin/flu-functions-interop.sh

# Fetches user input parameters	
getParams

# Sets default state to server unavailable
serverup=1
	
# Checks for availability of interop server
while [ $serverup -eq 1 ]
do
	nc -i 2 -vz $localip $port
	serverup=$?
	sleep 2
done

# Change to interop client directory
cd $user/interop/client

# Run the interop client python script with required inputs
sudo python interop_cli.py --url http://$localip:$port --username $username \
--password $password mavlink --device $deviceip

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 14 January 2020
