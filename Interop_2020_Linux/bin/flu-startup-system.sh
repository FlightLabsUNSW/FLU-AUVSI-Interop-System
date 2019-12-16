#!/bin/bash
# Startup script for all systems, FLU AUVSI 2020
# Marco Alberto, December 2019

# Determines the root directory
user=$(pwd)

# Include functions and information from other scripts
source $user/bin/flu-functions-interop.sh
source $user/bin/flu-functions-server.sh

gnome-terminal --window -e $user/bin/flu-main-interop.sh

# Start interop server
if [ $1 = "setup" ]
then
	setupServer
	startServer
else
	startServer
fi
