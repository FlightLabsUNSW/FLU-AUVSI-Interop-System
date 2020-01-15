#!/bin/bash

# Startup script for all systems

# Determines the root directory
cd
cd FLU-AUVSI-Interop-System/Interop-Linux
user=$(pwd)

# Include functions and information from other scripts
source $user/bin/flu-functions-object.sh
source $user/bin/flu-functions-server.sh
source $user/bin/flu-functions-setup.sh

# Change permissions to ensure scripts can be run
chmod u+x $user/bin/flu-main-object.sh
chmod u+x $user/bin/flu-main-mavproxy.sh
chmod u+x $user/bin/flu-main-server.sh
chmod u+x $user/bin/flu-main-client.sh

# Fetches user input parameters
getParams

# Starts the server (stop server using ctrl+C)
gnome-terminal --window -t "Interop Server Terminal" --geometry=78x23+0-0 \
-- $user/bin/flu-main-server.sh

# Sends the interop client to a new terminal
gnome-terminal --window -t "Object Upload Terminal" --geometry=78x23+0+0 \
-- $user/bin/flu-main-object.sh

# Sends mavproxy telemetry splitting to a new terminal
gnome-terminal --window -t "MAVProxy Terminal" --geometry=78x23-0-0 \
-- $user/bin/flu-main-mavproxy.sh
      
# Sends the telemetry upload system to a new terminal
gnome-terminal --window -t "Telemetry Upload Terminal" --geometry=78x23-0+0 \
-- $user/bin/flu-main-client.sh
	
# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 15 January 2020
