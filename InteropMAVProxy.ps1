<#
MAVProxy Telemetry Setup

This script changes the directory to the appropriate directory, and then takes an input MAVLink stream and sends it out
to multiple different IP addresses (one locally, and one on the VM). Ensure that the UAV is on and the telemetry link is
up, otherwise this will fail.

Note:

To stop the stream, just hit Ctrl+C, and this will interrupt the 

#>


# Changes the directory to the MAVProxy Files
cd C:\Program Files (x86)\MAVProxy

# Runs the MAVProxy executable, with the master input on COM3 USB port, and two outputs (one local and one to the VM)
mavproxy.exe --master="com3" --out=192.168.1.14:14550 --out=192.168.1.17:14550

#### CHECK THE COM PORT AND LOCAL/VM IP ADDRESSES ####