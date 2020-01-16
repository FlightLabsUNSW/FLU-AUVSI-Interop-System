#!/bin/bash

# Tutorial 2 - Telemetry Upload

RED='\033[0;32m'
NC='\033[0m'

cd
cd FLU-AUVSI-Interop-System/Interop-Linux
user=$(pwd)

echo "Welcome to the FLU Interop System Tutorials!"
sleep 2 ; echo
echo "This is Tutorial 3 in the FLU Interop System series."
sleep 2 ; echo
echo "In this tutorial, we will be showing the processes to upload objects to the interop server."
sleep 2 ; echo
echo "Have you done Tutorial 1 or 2 and kept the interop server running?"
echo "Enter 'y' or 'n' without quotes below:"
read serverUp

if [ $serverUp = 'y' ]
then
        echo "Thank you. Continuing the script." ; sleep 2
        
elif [ $serverUp = 'n' ]
then
        echo "No problems. Starting the interop server now, standby..." ; sleep 2
        gnome-terminal --window --title "Interop Server Terminal" --geometry=78x23+0-0 -- $user/bin/flu-main-server.sh ; sleep 2
        echo "Please enter your sudo password in the new terminal if prompted." ; sleep 2
        echo "Please press enter once the server has started."
        read wait1
        echo "Continuing the script..." ; sleep 2
        
else
        echo "Bad or no input, exiting..." ; sleep 2
        exit
fi

echo "The final part of the interop system is the object uploading process, which takes a ZIP file containing a JSON and a JPG/PNG file and uploads it to the interop server for verification."
sleep 2 ; echo
echo "Upon logging into this process, all of the mission details, including objects to avoid are printed to the mission-details.json file."
sleep 1 ; echo
echo "The object uploading process will now be started..."
gnome-terminal --window --title "Object Upload Terminal" --geometry=78x23-0-0 -- $user/bin/flu-main-object.sh ; sleep 2

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 16 January 2020
