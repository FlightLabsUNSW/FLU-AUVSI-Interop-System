#!/bin/bash

# MAVProxy starting script

# Determines the root directory
user=$(pwd)

# Include functions and information from other scripts
source $user/bin/flu-functions-object.sh

getParams

cd

# Start mavproxy outputting of telemetry
mavproxy.py --master=$comport --out=$deviceip --out=$localip:14550

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 14 January 2020
