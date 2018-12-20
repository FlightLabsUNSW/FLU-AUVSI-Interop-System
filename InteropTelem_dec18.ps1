<#
AUVSI SUAS Interoperability Client 2019 - Telemetry Upload

These lines of code are to be run in Ubuntu 18.04, and will automatically convert a MAVLink telemetry
stream into the appropriate format used for the compeititon, and then upload the converted telemetry data.
This will continue to run, so long as the MAVProxy and interactive container terminals remain open, and
the UAV is on and sending data.

DO NOT RUN IN POWERSHELL

Note: This script should be run using Ubuntu OS (18.04) with Docker and MAVProxy installed onto the device.
Note 2: Two Ubuntu terminals must be used (one for each of the following lines of code, as they will only be 
        stopped at the end of the competition mission.
Note 3: DO NOT STOP THESE TERMINALS AT ANY POINT DURING THE MISSION, OTHERWISE DEATH WILL ENSUE (legit).
Note 4: Make sure it is run in this order, with the 3DR radio already connected to the UAV and the UAV is ON

#>



## Terminal 1 ##
# This will start MAVProxy and port telemetry data to all ports chosen

# Add any additional output IP addresses for extra devices
mavproxy.py --master=/dev/ttyUSB0 --out=udp:192.168.1.11:14550 --out=udp:192.168.1.13:14550 
##### DOUBLE CHECK ALL IP ADDRESSES INCLUDING LOCAL ONE #####




## Terminal 2 ##
# This will start an interactive container of the interop client to send telemetry continuously

sudo docker pull auvsisuas/interop-client:2018.12
sudo docker run --net=host --interactive --tty auvsisuas/interop-client:2018.12
#in the interactive container run:
./tools/interop_cli.py --url http://192.168.1.13:8000 --username testuser --password testpass mavlink --device 192.168.1.11:14550
# url is the interop server url, CHANGE USERNAME AND PASSWORD, device is the local output (i.e. your local ip) with the specified port above