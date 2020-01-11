#!/bin/bash
# Startup script for all systems, FLU AUVSI 2020

# Determines the root directory
user=$(pwd)

# Include functions and information from other scripts
source $user/bin/flu-functions-interop.sh
source $user/bin/flu-functions-server.sh

# Change permissions to ensure scripts can be run
chmod u+x $user/bin/flu-main-interop.sh
chmod u+x $user/bin/flu-main-mavproxy.sh
chmod u+x $user/bin/flu-main-server.sh
chmod u+x $user/bin/flu-main-client.sh

# Installs all programs required 
if [ $1 = "setup" ]
then
	# Sets up and install all required packages
	setupPrograms

	# Sets up and installs interop database 
	setupServer
	
	echo "Please restart your computer to finish the installation processes."

elif [ $1 = "start" ]
then
	# Fetches user input parameters
        getParams
	
	# Starts the server (stop server using ctrl+C)
	gnome-terminal --window -- $user/bin/flu-main-server.sh

	# Sends the interop client to a new terminal
	gnome-terminal --window -- $user/bin/flu-main-interop.sh

	# Sends mavproxy telemetry splitting to a new terminal
	gnome-terminal --window -- $user/bin/flu-main-mavproxy.sh
      
	# Sends the telemetry upload system to the existing terminal
	startTelemetryStream
	
elif [ $1 = "comp" ]
then
	# Fetches user input parameters
        getParams
	
	# Sends the interop client to a new terminal
	gnome-terminal --window -- $user/bin/flu-main-interop.sh

	# Sends mavproxy telemetry splitting to a new terminal
	gnome-terminal --window -- $user/bin/flu-main-mavproxy.sh

	# Sends the telemetry upload system to the existing terminal
	startTelemetryStream
fi

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 11 January 2020
