#!/bin/bash

#test - getting there... only this file to fix
# 1. work out file reference through pwd and make sure sources and .py work
# 2. install jq for getParams function (in dockerfile)
# 3. test this bad boy

# Add other files for reference
source ./bin/flu-functions-interop.sh
source ./bin/flu-functions-server.sh

# Fetches user input parameters	
getParams

./interop/client/tools/interop_cli.py --url http://$localip:$port --username $username --password $password mavlink --device $deviceip
