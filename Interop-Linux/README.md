# AUVSI SUAS 2020 FLU Interop Interface
Following the successful implementation of the 2019 System at the AUVSI SUAS competition, a new revision of the same system has been developed to optimise the uploading of objects, while also making implementation with the computer vision and Linux ground station considerably easier for the 2020 competition. Once complete, ideally, only one script will be required to be run, which will start the interop interface, interop server (if required for testing) and telemetry upload to the server. As of January 2020, these scripts are complete, with minor changes and enhancements required.  

**NOTE: These files, commands, scripts and functions will only run on a Linux-based operating system, and have been tested on Ubuntu 18.04.**  

## Downloading the Interop System Code
In order to create a local copy of the github repository, run the following lines of code to install git and then create a copy of the repository locally (and ensure you use your github associated email):  

`sudo apt-get install git`  
`git config --global user.email <<your-email-here>>`  
`git clone https://github.com/FlightLabsUNSW/FLU-AUVSI-Interop-System.git`  

You should then see the whole file structure in the 'FLU-AUVSI-Interop-System' folder in the home directory, and everything you need for this system is contained in these folders.  

In addition to this, you can run the 'git-functions.sh' script as below, which updates the local repository from the master, using "update" as the input parameter for the script.  

`chmod u+x ./FLU-AUVSI-Interop-System/Interop-Linux/bin/git-functions.sh`  
`./FLU-AUVSI-Interop-System/Interop-Linux/bin/git-functions.sh update`  

It is good practice to do this every time before you start working locally if you are editing files, to ensure you have the latest version.  

## Program & Package Setup
For ease of installation and setup on different computers, a setup script has been developed, the 'flu-setup.sh' file. To be able to run the setup script, run the following lines of code:  

`cd FLU-AUVSI-Interop-System/Interop-Linux`  
`chmod u+x ./bin/flu-setup.sh`  
`./bin/flu-setup.sh`  

This script will install all of the required programs and python packages for the interop system. It will also create five desktop icons, which will run all of the required components for competition or non-competition testing, as well as the three provided tutorials.  

## User Input Requirements
To easily collate user-generated information and not require constant re-inputting of data on every upload, the "mission-params.json" file is used. In this file, the following parameters can be configured:  

- ID: Used for debugging only  
- IP: Raw IP address of the interop server (i.e. 192.168.1.16)  
- Mission ID: Mission ID given to the team (if unsure, use 1)  
- Port: Raw port of the interop server (i.e. 8000)  
- Username & Password: Login details for the interop server (if unsure, use testuser/testpass)  
- Device IP: Full IP address (including port) for telemetry output from MAVProxy (i.e. 192.168.1.16:14551)  
- Comport: Serial USB port where telemetry is going into the computer system (i.e. /dev/ttyUSB0)  

**These parameters must be updated prior to starting the system, and must be set by the user (they are not auto-generated).**  

## Full Interop System Use & Testing
While each of the scripts for each aspect of the interop system will run independently (for the most part), this is not their intended use. Two desktop shortcuts created during the setup script can be used to start the entire system, with a description as follows:  

1. Non-Comp Startup --> Runs the interop judging server, along with the three main components (MAVProxy, Object Upload, Telemetry Upload).  
2. AUVSI Startup    --> Runs the three main components (MAVProxy, Object Upload, Telemetry Upload), assuming the judging server is running remotely.  

**NOTE:** Be aware of your IP address and any user inputs, and ensure that these are up to date prior to starting the system.  

### Tutorials
In addition to the above startup scripts, three different tutorials have been created to become familiar with each of the different components of the interop system, as described below:  

1. Tutorial 1 - Interop Server  
2. Tutorial 2 - Telemetry Upload  
3. Tutorial 3 - Object Upload (still in progress)  

Each of these tutorials can be run using the desktop shortcuts, and follow the on-screen prompts within the terminals to work through each tutorial.  

### Mission Planning and Ground Station Software
As we are now running a Linux-based OS, Mission Planner (MP) is less favourable. Instead, QGroundControl (QGC) can be used with similar functionality to MP. To make sure you are receiving telemetry, you can install and run QGC, using the following link along with the associated documentation:  

[QGroundControl Installation & Documentation](https://docs.qgroundcontrol.com/en/getting_started/download_and_install.html)  

**NOTE:** In most scenarios, only run QGC after you have connected to the Interop Server and started telemetry upload, otherwise the auto-connect feature will take the USB serial line and not allow for MAVProxy to split the telemetry stream.  

### Interop Server Judging Interface
For the documentation in the 2019 competition, a YouTube video explaining the interop system was created using a series of screen recordings, and can be found at the following link:  

[AUVSI SUAS Judging Server Walkthrough](https://www.youtube.com/watch?v=nwT3D7kThdo)  

Refer to the following timestamps for information on the respective parts of the Interop Server used for judging:  

1.  2:15 -  2:40 --> Interop server login  
2. 14:00 - 16:55 --> Telemetry receiving screen, ODLCs review, team evaluation, editing interop server data  

Be aware that the server has since been updated with very minor interface changes, so using the current version will look slightly different to the interface seen in the video.  

### Viewing Live KMZ/KML Data
**Has not been tested yet on full missions due to time restrictions before AUVSI 2019**  

### Automatic Mission Evaluation
**Has not been tested yet on full missions due to time restrictions before AUVSI 2019**  

# Detailed Code Information
This section outlines some more detailed information about the code behind the interop system, including the file structure and source control for changes to the system. Please be careful editing code and make any changes locally, test them, and then commit them to the git repo.

## Main Scripts
These scripts contain the main code bodies and function calling, and are named 'flu-main-******.sh' in the Interop-Linux bin folder, with each file described briefly below:  

1. **flu-main-object.sh** - Main code body associated with the interaction with the interop server, which includes uploading of objects and images, login process, extraction of mission details, and watching for files to come from the drone to the ground station.  
2. **flu-main-mavproxy.sh** - Main code body associated with the splitting of telemetry to multiple different sources, including the interop system, QGroundControl ground station, and any other network locations where required.  
3. **flu-main-server.sh** - Main code body associated with starting the interop server locally.  
4. **flu-main-client.sh** - Main code body associated with the telemetry uploading, and involves running a provided python script from the AVUSI Interop code repository.  

## Function Scripts
These scripts contain the main functions associated with the main scripts, and are named 'flu-functions-******.sh' in the Interop-Linux bin folder. There are three function scripts.  

1. **flu-functions-object.sh** - Functions that are used in the object upload process, along with any other general functions.  
2. **flu-functions-server.sh** - Functions that are used in the setup of the server.  
3. **flu-functions-setup.sh** - Functions that are used in the setup of the system as a whole, including the installation of programs onto the local system.  

## File Structure
The file structure is extremely important, as majority of the locations are hard-coded into the system. Please **DO NOT** change the file structure of the Github unless it has been discussed and changed in the code. All of the main code is in the 'bin' folder, and all of the scripts reside in this folder.  

**The interop folder is generated automatically and will be updated whenever you run the setup script. Please do not delte or move this folder otherwise everything breaks!**  

Within the 'bin' folder, there are six different folders which contain varying amounts of information, code, or are used as temporary locations for files during the interop system operation. The purpose of these folders is described below:  

1. **archive** - All files, after being uploaded to the interop server, end up in this folder for easy checking of uploading and verifying correct objects.  
2. **plane-data** - Folder where the zip folders from the plane will arrive in, and is being watched by the system for the arrival of zip folders.  
3. **test-data** - Folder for the storage of dummy objects in zip folders, containing a json and jpg file.  
4. **tutorials** - Folder containing all of the tutorials to understand the code a bit easier and step through the processes and functions used.  
5. **not-in-use** - Folder containing the code which is not being used, or is otherwise messy. Don't look in here, it's where the monsters hide.  
6. **output-files** - Folder containing files which are created by the FLU interop system and are required for login or object upload. Do not touch these files at any point (except mission-details.json, which will be needed for mission planning purposes).  

## Debugging
Most debugging can be done in the command line interface, with reasonable error codes and locations presented in the case of failures in the system. A few common errors that have been found so far:  

1. **Denied permissions for running scripts** - run the following line of code to allow the running of a particular script:  
`chmod u+x /path-to-source/filename.extension`  
2. **Terminals appearing & disappearing** - check that telemetry radio is plugged in first and is attached to a USB port. There will be three terminals open at the competition (four during testing with server) under normal operating conditions.  

This section will be expanded upon when other running errors are identified and mitigated, either in code or through a short input as above.  

## Source Control
If you are editing local files, instead of having to copy/paste or reupload files individually, git can be used to add, commit and push files directly to the master branch from local.  

`cd FLU-AUVSI-Interop-System/Interop-Linux`  
`git add bin`  
`git commit`  

A screen will appear, prompting you to add a commit message, please make it concise and descriptive.  
When you are done, press Ctrl+X, type 'y', then press Enter to confirm the commit. To finish, run:  

`git push`  

Instead of running these four lines individually, the 'git-functions.sh' script can be run again using "upload" as the input parameter.  

`./FLU-AUVSI-Interop-System/Interop-Linux/bin/git-functions.sh upload`  

You will be required to log in to push commits to the master branch, so be sure to have access to the FLU github and know your username and password.  
If you require access, please talk to Marco, Anthony or Ed about this.  

# Code Notes
System: Linux (Ubuntu 18.04)  
Language: Shell & Python  
Developer: Marco Alberto  
Most Recent Update: 16 January 2020  

**Happy Interop Coding and Testing!!!**  
