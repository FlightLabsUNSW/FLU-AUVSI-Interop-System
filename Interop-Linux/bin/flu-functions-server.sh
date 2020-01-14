#!/bin/bash

# Server setup and startup functions, FLU AUVSI SUAS

# Internet connection required for setup, router connection required for startup

# Function for setting up the interop server for the first time (usage: setupServer)
function setupServer {
        
	# Find the root directory
	user=$(pwd)

	# Pull the interop server and client information from the docker image
	sudo docker pull auvsisuas/interop-server:2019.10
	sudo docker pull auvsisuas/interop-client:2019.10
	
	# Clone interop repository and move to the server folder
        sudo rm -r interop
	git clone https://github.com/FlightLabsUNSW/interop.git
	cd $user/interop/server
               
        
	# Create and load database and data
	sudo ./interop-server.sh create_db
	sudo ./interop-server.sh load_test_data
        
        # Install and build client packages (may throw errors but still work)
        cd $user/interop/client
        sudo python3 setup.py install
        sudo python setup.py build
}

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 14 January 2020
