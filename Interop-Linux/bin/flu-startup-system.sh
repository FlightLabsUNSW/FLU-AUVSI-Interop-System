#!/bin/bash
# Startup script for all systems, FLU AUVSI 2020
# Marco Alberto, December 2019

# Determines the root directory
user=$(pwd)

# Include functions and information from other scripts
source $user/bin/flu-functions-interop.sh
source $user/bin/flu-functions-server.sh

# Installs all programs required 
setupPrograms

# Sends the interop client to a new terminal (server requires own terminal)
gnome-terminal --window -e $user/bin/flu-main-interop.sh

# Start interop server
if [ $1 = "setup" ]
then
	# Sets up and installs interop database 
	setupServer

	# Starts the server (stop server using ctrl+C)	
	startServer

elif [ $1 = "start" ]
then
	# Starts the server (stop server using ctrl+C)
	startServer
fi

# Use no input at competition, as server does not need to be run
