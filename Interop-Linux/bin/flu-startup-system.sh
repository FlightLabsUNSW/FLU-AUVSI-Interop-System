#!/bin/bash
# Startup script for all systems, FLU AUVSI 2020
# Marco Alberto, December 2019

# Determines the root directory
user=$(pwd)/FLU-AUVSI-Interop-System/Interop-Linux

# Include functions and information from other scripts
source $user/bin/flu-functions-interop.sh
source $user/bin/flu-functions-server.sh

# Change permissions to ensure scripts can be run
chmod u+x $user/bin/flu-main-interop.sh
chmod u+x $user/bin/flu-main-mavproxy.sh
chmod u+x $user/bin/flu-main-server.sh

# Fetches user input parameters
getParams

# Installs all programs required 
if [ $1 = "setup" ]
then
	# Sets up and install all required packages
	setupPrograms

	# Sets up and installs interop database 
	setupServer
	
	echo "Please close and reopen the terminal to finish the installation processes."

elif [ $1 = "start" ]
then
	# Starts the server (stop server using ctrl+C)
	gnome-terminal --window -- $user/bin/flu-main-server.sh

	# Sends the interop client to a new terminal (requires own terminal)
	gnome-terminal --window -- $user/bin/flu-main-interop.sh

	# Sends mavproxy telemetry splitting to a new terminal (requires own terminal)
	gnome-terminal --window -- $user/bin/flu-main-mavproxy.sh

	# Sends the telemetry upload system to the existing terminal (requires own terminal)
	startTelemetryStream
	
elif [ $1 = "comp" ]
then
	# Sends the interop client to a new terminal (requires own terminal)
	gnome-terminal --window -- $user/bin/flu-main-interop.sh

	# Sends mavproxy telemetry splitting to a new terminal (requires own terminal)
	gnome-terminal --window -- $user/bin/flu-main-mavproxy.sh

	# Sends the telemetry upload system to the existing terminal (requires own terminal)
	startTelemetryStream
fi
