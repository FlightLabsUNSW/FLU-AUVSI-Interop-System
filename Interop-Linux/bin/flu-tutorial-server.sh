#!/bin/bash

# Tutorial 1 - Server Setup and Walkthrough

# For permissions errors, run chmod u+x ./FLU-AUVSI-Interop-System/Interop-Linux/bin/flu-tutorial-server.sh
# Run using ./FLU-AUVSI-Interop-System/Interop-Linux/bin/flu-tutorial-server.sh

user=$(pwd)/FLU-AUVSI-Interop-System/Interop-Linux

source $user/bin/flu-functions-server.sh

echo "Welcome to the FLU Interop System Tutorials!"
echo "In this tutorial, we will be learning about setting up the interop server and then you can explore the server."
echo 
echo "First, have you installed all the programs using the flu-startup-systems.sh script (y/n)?"

read programsSetup

if [ $programsSetup = "y" ]
then
	echo "Thank you!"

elif [ $programsSetup = "n" ]
then
	echo "Programs will now be installed automatically using those scripts."
	setupPrograms
	setupServer
	echo "Please restart your device and then re-run this script with a 'y' input."
	echo "If you are interested in the programs installed, have a look at the 'flu-functions-server.sh' script for more details. "

else
	echo "Please input either 'y' or 'n'"
	exit

fi

echo "Now with all the prerequisite software installed, the interop server can be run."
echo "The interop server must be run in a separate terminal, as it is a continuous process. It can be stopped by closing the terminal or using 'Ctrl+C'."
echo
echo "Starting interop server..."

gnome-terminal --window -- $user/bin/flu-main-server.sh

sleep 5

echo "The interop server will now start and run - it can be accessed at http://localhost:8000. Opening in your default web browser now..."

xdg-open http://localhost:8000

echo "Keep following the continuing instructions here to dive deeper into the interop server."
