#!/bin/bash

# Stops and removes any existing container created
sudo docker stop flu-cli
sudo docker rm flu-cli

# Build the docker image
sudo docker build -t flu-client:new --label flu-client -f ./bin/Dockerfile .

# Run the docker container from the image
sudo docker run -d -it --name flu-cli flu-client:new

# Start the docker container
sudo docker start flu-cli

# Execute bash script inside the container to start telemetry stream
sudo docker exec flu-cli ./bin/hello-world.sh

# Code Notes
# System: Linux (Ubuntu 18.04)
# Language: Shell
# Developer: Marco Alberto
# Most Recent Update: 11 January 2020
