#!/bin/bash

# Tutorial 2 - Telemetry Upload

RED='\033[0;32m'
NC='\033[0m'

cd
cd FLU-AUVSI-Interop-System/Interop-Linux
user=$(pwd)

echo "Welcome to the FLU Interop System Tutorials!"
sleep 2 ; echo
echo "This is Tutorial 2 in the FLU Interop System series."
sleep 2 ; echo
echo "In this tutorial, we will be showing the processes to upload telemetry to the interop server."
sleep 2 ; echo
echo "Have you done Tutorial 1 and kept the interop server running?"
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
        echo "Bad or no input, exiting..." ; sleep 3
        exit
fi

echo "In order to upload telemetry to the interop server, two processes must be running."
sleep 2 ; echo
echo "These processes are MAVProxy (which splits the telemetry stream to multiple IP addresses)"
echo "and a Python script which sends the telemetry packages to the server."
sleep 5 ; echo
echo -e "${RED} Please ensure WREN (or your test airframe) is powered on and telemetry radio is connected to your PC!${NC}"
sleep 2 ; echo
echo -e "Please also check the mission-params.json file, and change the 'ip' and 'deviceip' to the correct addresses for your PC. ${RED} DO NOT CHANGE ANY OTHER DETAILS, INCLUDING THE PORT ON 'deviceip' OR 'port'!!${NC}"
echo "Press enter to continue once you have checked these things."
read wait2
echo "First, MAVProxy will be run in a new terminal, and that terminal does not require any user interaction."
gnome-terminal --window --title "MAVProxy Terminal" --geometry=78x23-0-0 -- $user/bin/flu-main-mavproxy.sh
sleep 5 ; echo
echo "Now with MAVProxy running, the python script to upload telemetry can be run, and may require a sudo password input in the new terminal."
gnome-terminal --window --title "Telemetry Upload Terminal" --geometry=78x23-0+0 -- $user/bin/flu-main-client.sh
sleep 5 ; echo
echo "Now navigate to the following web address, http://localhost:8000, and login using the login details below:"
echo "username: testadmin" 
echo "password: testpass"
sleep 5 ; echo 
echo "Click on 'Mission 1' and you should see a large yellow box with latitude, longitude and altitude (in feet)."
echo "If you see this, it means the server is receiving telemetry from your drone, congrtulations!"
sleep 5 ; echo
echo "For more detailed information on the interop server, refer to the Github README found in the Interop-Linux folder."
sleep 2 ; echo
echo "If you have encountered any errors, please re-run the flu-setup.sh file, and check the mission-params.json file. If these errors persist, contact Marco."
sleep 2 ; echo
echo "This tutorial is now finished! This terminal will close in 60 seconds."
sleep 60

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 16 January 2020
