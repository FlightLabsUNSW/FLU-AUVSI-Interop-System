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
Name=Non-Comp Startup
Comment=Non-competition startup script' > Non-Comp-Start.desktop

echo '[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec='$user'/bin/flu-startup-competition.sh
Name=AUVSI Startup
Comment=Competition startup script' > Comp-Start.desktop

echo '[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec='$user'/bin/tutorials/flu-tutorial-server.sh
Name=Tutorial 1 - Interop Server
Comment=Tutorial for starting the interop server' > Tutorial-1.desktop

echo '[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec='$user'/bin/tutorials/flu-tutorial-telemetry.sh
Name=Tutorial 2 - Telemetry Upload
Comment=Tutorial for uploading telemetry to the interop server' > Tutorial-2.desktop

echo '[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec='$user'/bin/tutorials/flu-tutorial-object.sh
Name=Tutorial 3 - Object Upload
Comment=Tutorial for uploading objects to the interop server' > Tutorial-3.desktop

# Allow execution of these files from the desktop
chmod +x Comp-Start.desktop
chmod +x Non-Comp-Start.desktop
chmod +x Tutorial-1.desktop
chmod +x Tutorial-2.desktop
chmod +x Tutorial-3.desktop

# Good practice to restart after any installations
echo "Please restart your computer to finish the installation processes."

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 16 January 2020
