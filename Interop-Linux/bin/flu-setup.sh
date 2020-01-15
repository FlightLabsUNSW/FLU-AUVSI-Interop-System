#!/bin/bash

# Startup script for all systems

# Determines the root directory
user=$(pwd)

# Include functions and information from other scripts
source $user/bin/flu-functions-object.sh
source $user/bin/flu-functions-server.sh
source $user/bin/flu-functions-setup.sh

# Fetches user input parameters
getParams

# Sets up and install all required packages
setupPrograms

# Sets up and installs interop database 
setupServer

# Move to the Desktop directory
cd
cd Desktop

# Create desktop files for competition and non-competition scripts
echo '[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec='$user'/bin/flu-startup-non-competition.sh
Name=Non-Competition Startup
Comment=Non-competition startup script' > Non-Competition-Start.desktop

echo '[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec='$user'/bin/flu-startup-competition.sh
Name=Competition Startup
Comment=Competition startup script' > Competition-Start.desktop

# Allow execution of these files from the desktop
chmod +x Competition-Start.desktop
chmod +x Non-Competition-Start.desktop

# Good practice to restart after any installations
echo "Please restart your computer to finish the installation processes."

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 15 January 2020
