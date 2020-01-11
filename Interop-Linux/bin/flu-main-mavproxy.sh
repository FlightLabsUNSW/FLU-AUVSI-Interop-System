#!/bin/bash

# MAVProxy starting script

# Determines the root directory
user=$(pwd)

# Include functions and information from other scripts
source $user/bin/flu-functions-interop.sh
source $user/bin/flu-functions-server.sh 

getParams

cd

# Start mavproxy outputting of telemetry
mavproxy.py --master=$comport --out=$deviceip --out=$localip:14550

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 11 January 2020
