#!/bin/bash

# test - getting there... only this file to fix

# 1. make the .py file work
# 2. check for a server response in position outlined below (or some kind of server verification loop?? may require more installations?)

user=$(pwd)

chmod u+x $user/interop/client/tools/interop_cli.py

# Add other files for reference
source $user/bin/flu-functions-interop.sh
source $user/bin/flu-functions-server.sh

# Fetches user input parameters	
getParams

# check for server response!!!

cd $user/interop/client

./tools/interop_cli.py --url http://$localip:$port --username $username --password $password mavlink --device $deviceip

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 11 January 2020
