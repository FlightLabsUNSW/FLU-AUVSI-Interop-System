#!/bin/bash

# Telemetry upload script

# Determines the root directory
user=$(pwd)/FLU-AUVSI-Interop-System/Interop-Linux

# Include functions and information from other scripts
source $user/bin/flu-functions-interop.sh
source $user/bin/flu-functions-server.sh 

getParams

startServer
