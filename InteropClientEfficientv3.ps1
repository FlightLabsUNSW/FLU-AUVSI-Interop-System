<# 
AUVSI SUAS Interoperability Client System 2019 (Windows PowerShell)

This code is desgined to be run on Windows OS using Windows PowerShell (or ISE) for interaction
with the AUVSI SUAS Interop System, including logging in, the download of mission and obstacle details,
uploading of JSON and JPG files, continuous probing of a local directory for JSON or JPG files, and
upload telemetry data from the PixHawk continuously (MavProxy Integration).

NOTE: Any downloaded files should be opened with Notepad for ease of reading
NOTE 2: This was designed for the 2019 version of the competition, and may have changed since this implementation!
NOTE 3: If doing any local testing - be sure to run the InteropServer.ps1 file before running this script to get the judging system running.
NOTE 4: Each ODLC should be sent in a separate (numerically named increasing from 1) zip folder (which in turn contains the respective JSON and JPG files), otherwise this will not work.

#>

    # Initialise the required parameters that are used throughout the code - easier changes for IP/file location changes

$md = 'C:\Users\marco\MissionStuff'      ##### Arbitrary folder for mission stuff
$zippd = 'C:\Users\marco\PlaneData'      ##### Folder which receives the zip folders from the plane
$pd = 'C:\Users\marco\PlaneDataUnzip'    ##### Folder where the unzipped data from the plane is temporarily processed
$usbact = 'C:\Users\marco\usb1'          ##### Change this location to the 'actionable' USB provided by judges
$usbnonact = 'C:\Users\marco\usb2'       ##### Change this location to the 'non-actionable' USB
$archive = 'C:\Users\marco\archive'      ##### Make sure there's an appropriate folder directory for this to go into - local backup

$filter = "*.*"
$planeid = 1
$url = Read-Host -Prompt "Input the Interop System IP Address and Port"
"IP Address Accepted"
$missionid = Read-Host -Prompt "Input the Mission ID"
"Mission ID Accepted"
$username = Read-Host -Prompt "Input your username"
"Username Received"
$password = Read-Host -Prompt "Input your password"
"Password Received"

    # Set up the file to send to the server (general authentication)
$body = @{

    "username"="$username"
    "password"="$password"

} | ConvertTo-Json # Converts to object file from default (server only accepts JSON for login)

"Logging on..."

    # Send a JSON web request to the login page and create a session variable (effectively the cookie information)
Invoke-RestMethod -Uri "$url/api/login" -SessionVariable 'Session' -Method Post -Body $body -ContentType "application/json"

    # Get and save the mission details from the server - file would be mission.json (as a JSON file)
Invoke-RestMethod -Uri "$url/api/missions/$missionid" -WebSession $Session -Method Get -OutFile "$md\mission_data.json"

"Mission Details Retrieved from Interop Server"

    # Defines a period of time the loop will run for
$Timeout = 5400                     

    # Starts a stopwatch timer that counts from zero
$timer = [Diagnostics.Stopwatch]::StartNew()

    # Confirms the while loop is beginning
"Looking for objects and images..."

    # Creates a new object when at least one file is added to the given folder
$fsw = New-Object IO.FileSystemWatcher $zippd, $filter -Property @{IncludeSubdirectories = $false;NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'}

    # Registers the object with a specific identifier
Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated

    # Runs a while loop for the duration of $Timeout
while (($timer.Elapsed.TotalSeconds -lt $Timeout)) {
    
        # Pauses at this point until a file is added to the folder
    Wait-Event -SourceIdentifier "FileCreated"

        # Finds all of the files in the plane data folder (files to upload)
    $directoryInfo = Get-ChildItem "$zippd" | Measure-Object

        # Loops while there is still a file in the folder
    while (($directoryInfo.count -gt 0)) {  
       
            # Unzips the folder received from the plane to a separate folder
        Expand-Archive -Path "$zippd\$planeid.zip" -DestinationPath "$pd"

            # Determines how many files were sent from the zip folder
        $directoryInfo2 = Get-ChildItem "$pd" | Measure-Object
    
            # Defines two boolean values for whether a .json or .jpg file exists in the folder
        $b1 = Test-Path -Path "$pd\*" -Exclude '.json'
        $b2 = Test-Path -Path "$pd\*" -Exclude '.jpg'

            # Loops while there are files from the plane still in the temporary folder (i.e. makes sure all files from the zip folder are uploaded)
        while (($directoryInfo2.count -gt 0)) {
         
                # Determines if there is a json or jpeg file in the folder    
            if($b1 -eq $true -or $b2 -eq $true) {
            
                    # Finds all of the items in the specified folder
                $file = Get-ChildItem -Path "$pd"

                $k = 1

                    # Finds the name and extension of the first file in the folder
                $name = $file[$k].Name
                $ext = $file[$k].Extension

                    # Checks if the file extension of the first file is a json object file
                If ($ext -eq '.json') {                                                          
  
                        # Gets the content from the object file (in any format, preferred .json)
                    $object = Get-Content -Path "$pd\$name"
  
                        # Posts the object to the server and returns the object plus ID of the object
                    Invoke-RestMethod -Uri "$url/api/odlcs" -WebSession $Session -Method Post -Body $object -ContentType "application/json" -OutFile "$md\object_temp_file.json"  

                        # Copy the file to another folder/destination
                    Copy-Item -Path "$pd\$name" -Destination "$usbact\"

                        # Move the file to another folder/destination
                    Move-Item -Path "$pd\$name" -Destination "$archive\"
       
                        # Print a confirmation message that the file has been successfully sent                                             
                    "Object uploaded."

                        # Updates the number of files in the folder
                    $directoryInfo2 = Get-ChildItem "$pd" | Measure-Object

                    $k = $k - 1

                }  else {}

                $name = $file[$k].Name
                $ext = $file[$k].Extension
             
                    # Checks if the file extension of the first file is a jpeg image
                If ($ext -eq '.jpg') {
  
                        # Returns the details of the object submitted above as a string
                    $data = Get-Content -Path "$md\object_temp_file.json" | Out-String | ConvertFrom-Json

                        # Returns the ID of the object submitted above
                    $id = $data.id

                        # Defines the image directory string
                    $image = "$pd\$name"
  
                        # Posts the image to the server using the object ID from the json file sent
                    Invoke-RestMethod -Uri "$url/api/odlcs/$id/image" -WebSession $Session -Method Post -InFile $image -ContentType "image/jpeg"
                    
                        # Copy the file to another folder/destination
                    Copy-Item -Path "$pd\$name" -Destination "$usbact\"

                        # Move the file to another folder/destination
                    Move-Item -Path "$pd\$name" -Destination "$archive\"

                        # Updates the number of files in the folder
                    $directoryInfo2 = Get-ChildItem "$pd" | Measure-Object
 
                } else {}
            } else {}
        }
            # Moves the zip folder to the archive in case it is needed again
        Move-Item -Path "$zippd\$planeid.zip" -Destination "$archive\"

            # Adds 1 to the planeid count to account for the next folder coming in
        $planeid = $planeid + 1

            # Updates the number of objects in the folder
        $directoryInfo = Get-ChildItem "$zippd" | Measure-Object
    }

        # Removes the event so that the code waits until more files are added 
    Remove-Event -SourceIdentifier "FileCreated"

}

    # Stop the timer to avoid running for an infinite time
$timer.Stop()

    # Write a confirmation the script has ended --> Not often seen as Ctrl+C is usually used to stop prematurely to the timer stopping
"Exiting..."
