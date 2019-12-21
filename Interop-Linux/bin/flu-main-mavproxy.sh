#!/bin/bash

# MAVProxy starting script

# Start mavproxy outputting of telemetry
	mavproxy.py --master=$comPort --out=$deviceip --out=$localip:14551
