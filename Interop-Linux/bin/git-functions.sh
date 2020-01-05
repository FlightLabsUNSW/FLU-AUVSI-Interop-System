#!/bin/bash

# Script to manage source control using Git, FLU AUVSI 2020

# Update local code commands
if [ $1 = "update" ]
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

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 5 January 2020
