#!/bin/bash
# Functions for the Flight Labs UNSW AUVSI SUAS Interoperability System Interface
# For use on Ubuntu 18.04
# Developed by Marco Alberto, December 2019


function unzipFolder {

	zippy=$1
	fileArray=(${fileArray[@]} "$zippy")
	echo "$zippy"
	unzip ./$zippy -d /home/marco/bin/plane-data/extracted-data
	mv ./$zippy /home/marco/bin/archive
	echo "$zippy moved to archive"

}

function checkODLCs {

	curl -b /home/marco/bin/auth.txt -H 'Content-Type: application/json' -o /home/marco/bin/objects-total.json http://$localip:$port/api/odlcs

}

function uploadData {

	file=$2
	fileArray=(${fileArray[@]} "$file")
	echo "$file"
	cd
	
	if [ $1 = "json" ]
	then
		echo "The object file $file will be uploaded"
		fileName=$( basename $file .json)
		cd /home/marco/bin/plane-data/extracted-data
		curl -L -b /home/marco/bin/auth.txt -H 'Content-Type: application/json' -d "@$fileName.json" --output /home/marco/bin/object-temp.json http://$localip:$port/api/odlcs
		id=$(cat /home/marco/bin/object-temp.json | jq '.id')
		echo $id
		echo "The ID for the ODLC is $id."
	
	elif [ $1 = "jpeg" ]
	then
		echo "The image file $file will be uploaded"
		fileName=$( basename $file .jpeg)
		cd /home/marco/bin/plane-data/extracted-data
		curl -L -b /home/marco/bin/auth.txt -H 'Content-Type: image/jpeg' --data-binary "@$fileName.jpeg" http://$localip:$port/api/odlcs/$id/image
	
	elif [ $1 = "png" ] 
	then	
		echo "The image file $file will be uploaded"
		fileName=$( basename $file .png)
		cd /home/marco/bin/plane-data/extracted-data
		curl -L -b /home/marco/bin/auth.txt -H 'Content-Type: image/png' --data-binary "@$fileName.png" http://$localip:$port/api/odlcs/$id/image
	else
		echo "The file that was unzipped was not a JSON, JPEG or PNG and was not uploaded."
		echo "Your file will be archived, please check your file extension or name (no spaces)."	
	fi
	
	mv ./$file /home/marco/bin/archive
	echo "$file moved to archive"
	cd
	cd bin/plane-data

}
