#!/bin/bash

# Script to manage source control using Git, FLU AUVSI 2020

cd

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
	cd FLU-AUVSI-Interop-System/Interop-Linux

	# Adds the whole Linux folder (minus interop folder) to staging area for committing
	git add bin
	git add README.md

	# Commits changes in Linux folder
	git commit

	# Pushes changes to Github
	git push
fi

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 16 January 2020
