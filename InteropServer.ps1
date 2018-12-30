<#
AUVSI SUAS Interoperability System 2019 - Judging Server

This code is designed to run using Windows Os, with Docker for Windows installed on the local machine. Linux containers are
used for the program (do not use Windows containers). Running this code will publish the judging server to a local
port of your choice, allowing interaction with the entire system.

NOTE: To login to the judging system is different to the cilent - requiring 'testadmin' and 'testpass' to be able
to accesss the server.
NOTE 2: This server will NOT be accessible during the competition, so should not be relied upon for any confirmation
or code. YOU WILL NOT NEED TO RUN THIS CODE AT THE COMPETITION, IT WILL ALREADY BE RUNNING.

To run this script, open Windows PowerShell, type (without quotes) './InteropServer' if the file is in the C:\Users\marco directory (in my case)

#>

# Pulls the December 2018 version of the server from the docker hub
docker pull auvsisuas/interop-server:2018.12

# Runs the server and publishes it to the localhost on port 8001
docker run -d --restart=unless-stopped --interactive --tty --publish 8000:80 --name interop-server auvsisuas/interop-server:2018.12

# Stops the server from running
# docker stop interop-server

# Starts the server
# docker start interop-server
