#!/bin/bash

# Functions for the Flight Labs UNSW AUVSI SUAS Interoperability System Interface (Object Upload) script

# Functions are arranged in the order they are called in the flu-main-interop.sh script

# Function to login to the Interop Server and retrieve mission details (usage: interopLogin)
function interopLogin {

	# Call function to get login parameters
	getParams
	
	# Login messages
	echo "Data was successfully captured by the system, please wait..."
	echo "Logging on..."
	
	# Creation of JSON for login information
	echo {'"username":"'$username'","password":"'$password'"'} > $user/bin/body.json
	
	serverup=1
	echo $serverup
	
	# Checks for availability of interop server every 2 seconds
	while [ $serverup -eq 1 ]
	do
		nc -i 2 -vz $localip $port
		serverup=$?
		sleep 2
	done
	
	# Send HTTP POST request for Interop login and store session variable as a cookie
	curl -d @$user/bin/output-files/body.json -H 'Content-Type: application/json' \
	--cookie-jar $user/bin/output-files/auth.txt http://$localip:$port/api/login

	# Send HTTP GET request to Interop Server for mission details
	curl -L -b $user/bin/output-files/auth.txt --output $user/bin/output-files/mission-details.json \
	http://$localip:$port/api/missions/$missionID
}

# Function that unzips, sends files to another folder, and archives the zip folder, preserving it (usage: unzipFolder <fileArray>)
function unzipFolder {
	
	# Sets the first input to an local variable
	zippy=$1
	
	# Creates a file array with the files in the plane-data folder
	fileArray=(${fileArray[@]} "$zippy")
	echo "$zippy"
	
	# Unzips the zip folder and sends extracted data to new folder
	unzip ./$zippy -d $user/bin/plane-data/extracted-data
	
	# Moves file to archive folder
	mv ./$zippy $user/bin/archive
	echo "$zippy moved to archive"

}

# Function that is used to upload data to the Interop Server (usage: uploadData <fileExtension> <fileArray>)
function uploadData {
	
	# Set second function input to local variable
	file=$2
	
	# Create a file array with extracted files from the zip folder
	fileArray=(${fileArray[@]} "$file")
	echo "$file"
		
	# Takes and compares the first function input to check for the correct file extension
	if [ $1 = "json" ]
	then
		echo "The object file $file will be uploaded"
		
		# Extracts just the filename without extension
		fileName=$( basename $file .json)
		
		# Moves to the directory with the data in it
		cd $user/bin/plane-data/extracted-data
		
		# Sends a HTTP POST request and output the returned data to a temp json file
		curl -L -b $user/bin/output-files/auth.txt -H 'Content-Type: application/json' -d "@$fileName.json" \
		--output $user/bin/output-files/object-temp.json http://$localip:$port/api/odlcs
		
		# Read the ID of the ODLC from the temp file of the object just uploaded and print out confirmation
		id=$(cat $user/bin/output-files/object-temp.json | jq '.id')
		echo $id
		echo "The ID for the ODLC is $id."
	
	elif [ $1 = "jpeg" ]
	then
		echo "The image file $file will be uploaded"
		
		# Extracts just the filename without extension
		fileName=$( basename $file .jpeg)
		
		# Moves to the directory with data in it
		cd $user/bin/plane-data/extracted-data
		
		# Send a HTTP POST request with binary image data
		curl -L -b $user/bin/output-files/auth.txt -H 'Content-Type: image/jpeg' \
		--data-binary "@$fileName.jpeg" http://$localip:$port/api/odlcs/$id/image
	
	elif [ $1 = "png" ] 
	then	
		# Functions identically to jpeg if statement except with png file extension
		echo "The image file $file will be uploaded"
		fileName=$( basename $file .png)
		cd $user/bin/plane-data/extracted-data
		curl -L -b $user/bin/output-files/auth.txt -H 'Content-Type: image/png' \
		--data-binary "@$fileName.png" http://$localip:$port/api/odlcs/$id/image
	else
		# Print out error messages if the input isn't one of the expected values
		echo "The file that was unzipped was not a JSON, JPEG or PNG and was not uploaded."
		echo "Your file will be archived, please check your file extension or name (no spaces)."	
	fi
	
	# Moves the file to the archive, prints confirmation and returns to the plane-data folder
	mv ./$file $user/bin/archive
	echo "$file moved to archive"
	cd $user/bin/plane-data

}

# Function to get the parameters from the login json file (usage: getParams)
function getParams {
	
	# Takes the mission-params json file and extracts the required information	
	localip=$(cat $user/bin/mission-params.json | jq -r '.ip')
	missionID=$(cat $user/bin/mission-params.json | jq '.missionid')
	port=$(cat $user/bin/mission-params.json | jq '.port')
	username=$(cat $user/bin/mission-params.json | jq -r '.username')
	password=$(cat $user/bin/mission-params.json | jq -r '.password')
	deviceip=$(cat $user/bin/mission-params.json | jq -r '.deviceip')
	comport=$(cat $user/bin/mission-params.json | jq -r '.comport')
}

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 14 January 2020
