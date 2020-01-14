#!/bin/bash

# Setup functions for programs and packages used in this system

# Function for installing required programs (usage: setupPrograms)
function setupPrograms {

	# Install required programs required for startup and setup
	sudo apt-get -y install \
	docker \
	docker-compose \
 	python3-dev \
 	python3-opencv \
 	python3-pip \
 	python3-matplotlib \
 	python3-lxml \
 	python3-yaml \
	python-pip \
	curl \
	inotify-tools \
	jq ]
	zip \
	unzip \
	nmap \
	protobuf-compiler
	
	# Install python packages for client
	sudo pip -y install \
	protobuf \
	futures \
	MAVProxy
	
	# Additional MAVProxy setup code lines
	echo "export PATH=$PATH:$HOME/.local/bin" >> ~/.bashrc
	sudo adduser marco dialout
}

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 14 January 2020
