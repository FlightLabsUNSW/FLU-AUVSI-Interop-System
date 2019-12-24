#!/bin/bash

#test - getting there... only this file to fix

# Add other files for reference
source ./bin/flu-functions-interop.sh
source ./bin/flu-functions-server.sh

# Fetches user input parameters	
getParams

./interop/client/tools/interop_cli.py --url http://$localip:$port --username $username --password $password mavlink --device $deviceip
