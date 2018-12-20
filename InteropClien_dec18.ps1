<# 
AUVSI SUAS Interoperability Client 2019 - All but Telemetry Upload

This code is desgined to be run on Windows OS using Windows PowerShell (or ISE) for interaction
with the AUVSI SUAS Interop System, including logging in, the download of mission and obstacle details,
uploading of JSON and JPG files, continuous probing of a local directory for JSON or JPG files.

NOTE: Any downloaded files should be opened with Notepad for ease of reading
NOTE 2: This was designed for the 2019 version of the competition, and may have changed since this implementation!
NOTE 3: If doing any local testing - be sure to run the InteropServer.ps1 file before running this script to get the judging system running.

To run this script, open Windows PowerShell, type (without quotes) './InteropClient' if the file is in the C:\Users\marco directory (in my case)

#>

    # Initialise the required parameters that are used throughout the code - easier changes for IP/file location changes
$md = 'C:\Users\marco\MissionStuff' ##### Arbitrary folder for mission stuff #####
$pd = 'C:\Users\marco\PlaneData'    ##### Folder where the data from the plane is receieved ######
$usbact = 'C:\Users\marco\usb1'     ##### Change this location to the 'actionable' USB provided by judges ######
$usbnonact = 'C:\Users\marco\usb2'  ##### Change this location to the 'non-actionable' USB #####
$archive = 'C:\Users\marco\archive' ##### Make sure there's an appropriate folder directory for this to go into - local backup #####
$url = 'http://192.168.1.14:8000'   ##### DOUBLE CHECK THIS WHEN USING NON-STATIC IP ADDRESS OR DIFFERENT ROUTER/MACHINE ######
   
    # Set up the file to send to the server (general authentication)
$body = @{

    "username"="testuser"           ##### Change username #####
    "password"="testpass"           ##### Change password #####

} | ConvertTo-Json # Converts to object file from default (server only accepts JSON for login)

    # Send a JSON web request to the login page and create a session variable (effectively the cookie information)
Invoke-RestMethod -Uri "$url/api/login" -SessionVariable 'Session' -Method Post -Body $body -ContentType "application/json"

    # Get and save the mission details from the server - file would be mission.json (as a JSON file)
Invoke-RestMethod -Uri "$url/api/missions" -WebSession $Session -Method Get -OutFile "$md\mission.json"

    # Get and save the obstacle details from the server - file would be obstacles.json (as a JSON file)
Invoke-RestMethod -Uri "$url/api/obstacles" -WebSession $Session -Method Get -OutFile "$md\obstacles.json"

    <#
    NOTE: Files should be named and sent sequentially to the GS. This will ensure they are uploaded in the correct order.
    #>

    # Defines a period of time the loop will run for
$Timeout = 10
##### Change to greater than total mission time (i.e. >60 mins) #####

    # Starts a stopwatch timer that counts from zero
$timer = [Diagnostics.Stopwatch]::StartNew()

    # Confirms the while loop is beginning
"Looking for objects and images..."

##### This section may be updated to be more efficient/automated #####
##### Might be able to run the loop checking for a file in the folder instead of a timed loop #####
##### Double check filesystemwatcher functionality and try to get that working #####

    # Runs a while loop for the duration of $Timeout
while (($timer.Elapsed.TotalSeconds -lt $Timeout)) {
    
        # Defines two boolean values for whether a .json or .jpg file exists in the folder
    $b1 = Test-Path -Path "$pd\*" -Exclude '.json'
    $b2 = Test-Path -Path "$pd\*" -Exclude '.jpg'
    
        # Defines a time period to wait before running the loop again (delay function)
    Start-Sleep -Seconds 2
    
        # Determines if there is a json or jpeg file in the folder    
    if($b1 -eq $true -or $b2 -eq $true) {
    
            # Finds all of the items in the specified folder
        $file = Get-ChildItem -Path "$pd"

            # Finds the name and extension of the first file in the folder
        $name = $file[0].Name
        $ext = $file[0].Extension

            # Checks if the file extension of the first file is a json object file
        If ($ext -eq '.json') {                                                          
  
                # Gets the content from the object file (in any format, preferred .json)
            $object = Get-Content -Path "$pd\$name"
  
                # Posts the object to the server and returns the object plus ID of the object
            Invoke-RestMethod -Uri "$url/api/odlcs" -WebSession $Session -Method Post -Body $object -ContentType "application/json" -OutFile "$md\object.json"

                # Copy the file to another folder/destination
            Copy-Item -Path "$pd\$name" -Destination "$usbact\"

                # Move the file to another folder/destination
            Move-Item -Path "$pd\$name" -Destination "$archive\"
       
                # Print a confirmation message that the file has been successfully sent                                             
            "Object uploaded."

        }   
        else {} # Do nothing

            # Checks if the file extension of the first file is a jpeg image
        If ($ext -eq '.jpg') {
  
                # Returns the ID of the object submitted above as a string
            $data = Get-Content -Path "$md\object.json" | Out-String | ConvertFrom-Json
            $id = $data.id

                # Defines the image directory string
            $image = "$pd\$name"
  
                # Posts the image to the server using the object ID from the json file sent
            Invoke-RestMethod -Uri "$url/api/odlcs/$id/image" -WebSession $Session -Method Post -InFile $image -ContentType "image/jpeg"
    
                # Copy the file to another folder/destination
            Copy-Item -Path "$pd\$name" -Destination "$usbact\"

                # Move the file to another folder/destination
            Move-Item -Path "$pd\$name" -Destination "$archive\"
 
        }
        else {} # Do nothing
    }
    else {}     # Do nothing
}

    # Stop the timer to avoid running for an infinite time
$timer.Stop()

    # Write a confirmation the script has ended
"Exiting..."