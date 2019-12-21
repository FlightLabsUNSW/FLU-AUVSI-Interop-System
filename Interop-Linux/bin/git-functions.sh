#!/bin/bash

# Script to manage source control using Git, FLU AUVSI 2020
# Marco Alberto, December 2019

# Download commands
if [ $1 = "download" ]
then

	# Clone github repo locally
	 git clone https://github.com/FlightLabsUNSW/FLU-AUVSI-Interop-System

fi 

# Upload commands
if [ $1 = "upload" ]
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