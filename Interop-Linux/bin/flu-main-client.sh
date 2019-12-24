#!/bin/bash

# Currently under construction and working out the nitty gritty

# Change to root directory (needs to be run before running script...)
# cd FLU-AUVSI-Interop-System/Interop-Linux

# Stops and removes any existing container created
sudo docker stop flu-cli
sudo docker rm flu-cli
#sudo docker rmi flu-client

# Build the docker image
sudo docker build -t flu-client --label flu-client -f ./bin/Dockerfile .

# Filter the docker images for the client image
imageid=$(sudo docker images --filter "label=flu-client" --format "{{.ID}}")

echo $imageid

# Run the docker container from the image
sudo docker run -d -it --name flu-cli $imageid

# Start the docker container
sudo docker start flu-cli

# Execute bash script inside the container to start telemetry stream
sudo docker exec flu-cli ./bin/hello-world.sh
