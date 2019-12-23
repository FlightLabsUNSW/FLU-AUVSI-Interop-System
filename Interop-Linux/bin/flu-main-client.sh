#!/bin/bash

# Currently under construction and working out the nitty gritty
# Another file will accompany this, a Dockerfile, which allows for the building of a container that will eventually be used as the telemetry uploading system.

# Directory changes will happen - these files need to end up in the flu repo!
	# Dockerfile, hello-world.sh are in the /interop/client directory!!! 
# Make sure telemetry upload works running the interop_cli.py script in hello-world.sh before messing about with directory changes

# Change to root directory
cd

# Stops and removes any existing container created
sudo docker stop flu-cli
sudo docker rm flu-cli

# Build the docker image
sudo docker build -t flu-client --label flu-client -f interop/client/Dockerfile .

# Filter the docker images for the client image
imageid=$(sudo docker images --filter "label=flu-client" --format "{{.ID}}")

echo $imageid

# Run the docker container from the image
sudo docker run -d -it --name flu-cli $imageid

# Start the docker container
sudo docker start flu-cli

# Execute bash script inside the container to start telemetry stream
sudo docker exec flu-cli ./interop/client/hello-world.sh
	# update path and filename for telem stream
