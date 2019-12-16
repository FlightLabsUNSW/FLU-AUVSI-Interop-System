#!/bin/bash
# Server setup and startup functions, FLU AUVSI SUAS
# Marco Alberto, December 2019
# Internet connection required for setup, router connection required for startup

# Function for setting up the interop server for the first time
function setupInteropServer {

	# Find the root directory
	user=$(pwd)

	# Install required programs required for startup and setup
	sudo apt-get install docker
	sudo apt-get install docker-compose
	sudo apt-get install git

	# Pull the interop server and client information from the docker image
	sudo docker pull auvsisuas/interop-server:2019.10
	sudo docker pull auvsisuas/interop-client:2019.10
	
	# Clone interop repository and move to the server folder
	cd $user
	git clone https://github.com/auvsi-suas/interop.git
	cd $user/interop/server

	# Create and load database and data
	sudo ./interop-server.sh create_db
	sudo ./interop-server.sh load_test_data

}

# Function for removing all server containers and information (must be run when server is stopped)
function removeServer {

	# Find the root directory and change to the right directory
	user=$(pwd)
	cd $user/interop/server
	
	# Remove server data
	sudo ./interop-server.sh rm_data
	
}

# Function for upgrading the interop server information to a later docker image
function upgradeServer {

	# Find the root directory and change to the right directory
	user=$(pwd)
	cd $user/interop/server
	
	# Upgrade server data
	sudo ./interop-server.sh upgrade
}

# Function for starting the interop server
function startServer {

	# Find the root directory and change to the right directory
	user=$(pwd)
	cd $user/interop/server
	
	# Turn the interop server on (can be found at http://localhost:8000 or http://youripaddress:8000)
	sudo ./interop-server.sh up

}

# Function for starting the telemetry stream (requiring user input at the moment)
function startTelemetryStream {
	
	# Find the root directory and change to the right directory
	user=$(pwd)
	cd $user/interop/client
	
	export info="./tools/interop_cli.py --url http://$localip:$port --username $username --password $password mavlink --device $deviceip"

	# Runs the interop client in an interactive bash
	sudo docker run --net=host -e "info=$info" --interactive --tty auvsisuas/interop-client
	
	# Need to run "$info" without quotes in venv to start the telemetry stream
	
}
