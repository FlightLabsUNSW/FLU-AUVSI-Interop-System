#!/bin/bash

# Script to manage source control using Git, FLU AUVSI 2020
# Marco Alberto, December 2019

# Setup commands
if [ $1 = "setup" ]
then
	sudo apt-get install git
	echo "Please input your email associated with your Github account" ; read email
	git config --global user.email $email
	git clone https://github.com/FlightLabsUNSW/FLU-AUVSI-Interop-System.git

# Download commands
elif [ $1 = "download" ]
then
	# Change to root interop system folder
	cd FLU-AUVSI-Interop-System

	# Update or download the github repo
	 git pull https://github.com/FlightLabsUNSW/FLU-AUVSI-Interop-System.git

# Upload commands
elif [ $1 = "upload" ]
then
	# Change to root interop system folder
	cd FLU-AUVSI-Interop-System

	# Adds the whole Linux folder to staging area for committing
	git add Interop-Linux

	# Commits changes in Linux folder
	git commit

	# Pushes changes to Github
	git push
fi
