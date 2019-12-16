#!/bin/bash

# Welcome to the Flight Labs UNSW Interoperability System Interface, v1.4 on Ubuntu 18.04.
# This script was developed by Marco Alberto, December 2019.
# Check the Flight Labs UNSW Interoperability Github (https://www.github.com/
# Refer to AUVSI SUAS github (https://www.github.com/auvsi-suas/interop) for more details.
# Activate using ./bin/flu-main-interop.sh from root.
# Ensure whole bin file is downloaded and placed in the home directory.
# Use chmod u+x interop-login.sh if permissions are denied.


# Determines the root directory
user=$(pwd)

# Include functions and information from other scripts
source $user/bin/flu-functions-interop.sh

# Clear command line interface
clear

# Welcome messages
echo "Welcome to the Flight Labs UNSW Interoperability System Interface, v1.4 on Ubuntu 18.04."
echo "This script was developed by Marco Alberto, December 2019."
echo "Refer to AUVSI SUAS github (https://www.github.com/auvsi-suas/interop) for more details."
echo ""

# User inputs for mission parameters for easy use at the competition
uploadedObjects=0

# Calls function to login to Interop Server and retrieve mission details
interopLogin

# Loop to ensure a non-infinite runtime (maximum objects is ~30 for AUVSI)
while [ "$uploadedobjects" != "100" ]
do
	echo "Waiting for files in plane-data..."
		
	# Wait for a file to be added into the plane-data folder
	inotifywait -e moved_to $user/bin/plane-data

	# Delay for 2 seconds to ensure all files are moved to the folder
	sleep 2

	# Calculate number of files in the plane-data folder
	cd $user/bin/plane-data
	numFiles=$(expr $(find . -maxdepth 1 -type f -name "*.zip" | wc -l))
	
	# Loop to run if there are any zip files left in the plane-data folder
	while [ $numFiles -gt 0 ] 
	do
		# Number of zip files message
		echo "There were $numFiles zip folders found, pending upload."
  	
		# Loop for ZIP folders for unzip and uploading
		for zip in *.zip
		do
			# Calls the folder unzipping function
			unzipFolder $zip
						
			# Loop for JSON files uploading to interop server
			for json in *.json
			do
				# Calls the generalised uploading function				
				cd $user/bin/plane-data/extracted-data
				uploadData json $json
			done	
			
			# Loop for JPEG files uploading to interop server
			for jpeg in *.jpeg
			do
				# Calls the generalised uploading function				
				cd $user/bin/plane-data/extracted-data
				uploadData jpeg $jpeg
			done
			
		: '	# Loop for PNG files uploading to interop server (uncomment if using)
			for png in *.png
			do
				# Calls the generalised uploading function
				cd $user/bin/plane-data/extracted-data
				uploadData png $png
			done
		'
		# Add one to the uploaded objects sum
		uploadedObjects=$(expr $uploadedObjects + 1)
		echo "There have been $uploadedObjects objects uploaded so far."
		done
		
	# Calculate the number of files remaining
	numFiles=$(expr $(find . -maxdepth 1 -type f -name "*.zip" | wc -l)) 
	done
done

echo "Maximum number of objects uploaded, your mission is complete."
