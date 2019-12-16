#!/bin/bash
# Server setup and startup functions, FLU AUVSI SUAS
# Marco Alberto, December 2019
# Internet connection required for setup, router connection required for startup

# Function for installing required programs
function setupPrograms {

	# Usage: setupPrograms

	# Install required programs required for startup and setup
	sudo apt-get install docker
	sudo apt-get install docker-compose
	sudo apt-get install git
	
	# Install requirement programs used in scripts
	sudo apt-get install curl
	sudo apt-get install inotify-tools
	sudo apt-get install jq
	sudo apt-get install zip
	sudo apt-get install unzip
	sudo apt-get install nmap

}

# Function for setting up the interop server for the first time
function setupServer {

	# Usage: setupServer

	# Find the root directory
	user=$(pwd)

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

	# Usage: removeServer

	# Find the root directory and change to the right directory
	user=$(pwd)
	cd $user/interop/server
	
	# Remove server data
	sudo ./interop-server.sh rm_data
	
}

# Function for upgrading the interop server information to a later docker image
function upgradeServer {

	# Usage: upgradeServer

	# Find the root directory and change to the right directory
	user=$(pwd)
	cd $user/interop/server
	
	# Upgrade server data
	sudo ./interop-server.sh upgrade
}

# Function for starting the interop server
function startServer {

	# Usage: startServer

	# Find the root directory and change to the right directory
	user=$(pwd)
	cd $user/interop/server
	
	# Turn the interop server on (can be found at http://localhost:8000 or http://youripaddress:8000)
	sudo ./interop-server.sh up

}

# Function for starting the telemetry stream (requiring user input at the moment)
function startTelemetryStream {
	
	# Usage: startTelemetryStream

	# Find the root directory and change to the right directory
	user=$(pwd)

	serverup=1
	echo $serverup
	
	# Checks for availability of interop server
	while [ $serverup -eq 1 ]
	do
		nc -i 2 -vz $localip $port
		serverup=$?
		sleep 2
	done

	cd $user/interop/client
	
	export info="./tools/interop_cli.py --url http://$localip:$port --username $username --password $password mavlink --device $deviceip"

	# Runs the interop client in an interactive bash
	sudo docker run --net=host -e "info=$info" --interactive --tty auvsisuas/interop-client
	
	# Need to run "$info" without quotes in venv to start the telemetry stream
	# Trying to work out how to do this automatically...
	
}
