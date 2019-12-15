#!/bin/bash
# Main Script

# Notes:
# Welcome to the Flight Labs UNSW Interoperability System Interface, v1.4 on Ubuntu 18.04.
# This script was developed by Marco Alberto, December 2019.
# Check the Flight Labs UNSW Interoperability Github (https://www.github.com/
# Refer to AUVSI SUAS github (https://www.github.com/auvsi-suas/interop) for more details.
# Activate using ./bin/interop-login.sh from root.
# Ensure whole bin file is downloaded and placed in the home directory.
# Use chmod u+x interop-login.sh if permissions are denied.

: '
	TO DO:
	3. documentation and github structure review
	4. optimise file checking in extracted data folder
	5. clear or create files required (if they dont automatically when you call the functions)
'

# Include functions and information from other scripts
source /home/marco/bin/functions.sh

# Clear command line interface
clear

# Welcome messages
echo "Welcome to the Flight Labs UNSW Interoperability System Interface, v1.4 on Ubuntu 18.04."
echo "This script was developed by Marco Alberto, December 2019."
echo "Refer to AUVSI SUAS github (https://www.github.com/auvsi-suas/interop) for more details."
echo ""

# Set parameters if using set inputs all the time (or for testing)
#localip="192.168.1.16"
#port="8000"
#missionID="1"
#username="flu"
#password="flu"

# User inputs for mission parameters for easy use at the competition
uploadedObjects=0
echo -n "Enter the IP address and press Enter: " ; 		read localip
echo -n "Enter the four digit port and press Enter: " ; 	read port
echo -n "Enter the mission ID number and press Enter: " ; 	read missionID
echo -n "Enter the username and press Enter: " ; 		read username
echo -n "Enter the password and press Enter: " ; 		read password

# Login messages
echo "Data was successfully captured by the system, please wait..."
echo "Logging on..."

# Creation of JSON for login information
echo {'"username":"'$username'","password":"'$password'"'} > ./bin/body.json

# Interop login request and storage of session variable as a cookie
curl -d @./bin/body.json -H 'Content-Type: application/json' --cookie-jar ./bin/auth.txt http://$localip:$port/api/login

# Request mission details from interop server
curl -L -b ./bin/auth.txt --output ./bin/mission-details.json http://$localip:$port/api/missions/$missionID

# Loop to ensure a non-infinite runtime (maximum objects is ~30 for AUVSI)
while [ "$uploadedobjects" != "100" ]
do
	echo "Waiting for files in plane-data..."
		
	# Wait for a file to be added into the plane-data folder
	inotifywait -e moved_to /home/marco/bin/plane-data

	# Delay for 2 seconds to ensure all files are in the folder ***** TUNING REQUIRED *****
	sleep 2

	# Calculate number of files in the plane-data folder
	cd bin/plane-data
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
				cd /home/marco/bin/plane-data/extracted-data
				uploadData json $json
			done	
			
			# Loop for JPEG files uploading to interop server
			for jpeg in *.jpeg
			do
				# Calls the generalised uploading function				
				cd /home/marco/bin/plane-data/extracted-data
				uploadData jpeg $jpeg
			done
			
		: '	# Loop for PNG files uploading to interop server (uncomment if using)
			for png in *.png
			do
				# Calls the generalised uploading function
				cd /home/marco/bin/plane-data/extracted-data
				uploadData png $png
			done
		'
		
		# Add one to the uploaded objects sum
		uploadedObjects=$(expr $uploadedObjects + 1)
		echo "There have been $uploadedObjects objects uploaded so far."

		done
		
		# Calculate the number of files remaining
		numFiles=$(expr $(find . -maxdepth 1 -type f -name "*.zip" | wc -l))
		cd 
	done
done

echo "Maximum number of objects uploaded, your mission is complete."
