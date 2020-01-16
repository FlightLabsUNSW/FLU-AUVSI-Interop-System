#!/bin/bash

# Tutorial 1 - Interop Server Startup

cd
cd FLU-AUVSI-Interop-System/Interop-Linux
user=$(pwd)

echo "Welcome to the FLU Interop System Tutorials!"
sleep 2 ; echo
echo "This is Tutorial 1 in the FLU Interop System series."
sleep 2 ; echo
echo "In this tutorial, we will be setting up the interop server and then you can explore the server."
sleep 2 ; echo
echo "The interop server must be run in a separate terminal, as it is a continuous process."
echo "It can be stopped by using 'Ctrl+C', and should always be stopped using this method."
sleep 2 ; echo
echo "The interop server will now start and run. You may need to enter your sudo password." 

gnome-terminal --window -- title "Interop Server Terminal" --geometry=78x23+0-0 -- $user/bin/flu-main-server.sh

sleep 10 ; echo
echo "It can be accessed at http://localhost:8000. Opening in your default web browser now..."

xdg-open http://localhost:8000

sleep 10 ; echo
echo "Now feel free to explore the interop server, using the login details below:"
echo "username: testadmin" 
echo "password: testpass"
sleep 5 ; echo
echo "For more detailed information on the interop server, refer to the Github README found in the Interop-Linux folder."
sleep 2 ; echo
echo "If you have encountered any errors, please re-run the flu-setup.sh file. If these errors persist, contact Marco."
sleep 2 ; echo
echo "This tutorial is now finished! This terminal will close in 60 seconds."
sleep 60

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 16 January 2020
