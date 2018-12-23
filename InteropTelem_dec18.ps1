<#
AUVSI SUAS Interoperability Client 2019 - Telemetry Upload

These lines of code are to be run in Ubuntu 18.04, and will automatically convert a MAVLink telemetry
stream into the appropriate format used for the compeititon, and then upload the converted telemetry data.
This will continue to run, so long as MAVProxy (on Windows) and the interactive container terminal (on Ubuntu)
remain open, and the UAV is on and sending data.

##### DO NOT RUN IN POWERSHELL #####

Note: This script should be run using Ubuntu OS (18.04) with Docker installed onto the device.

#>

# This will start an interactive container of the interop client to send telemetry continuously
# (You may need your local password to run these commands)

sudo docker pull auvsisuas/interop-client:2018.12
sudo docker run --net=host --interactive --tty auvsisuas/interop-client:2018.12

# In the interactive container run (check notes below are correct):
./tools/interop_cli.py --url http://192.168.1.14:8010 --username testuser --password testpass mavlink --device 192.168.1.17:14550

#### URL is the interop server IP address ####
#### Check username and password ####
#### Device is any IP address you have access locally to ####
