#!/bin/bash
#Simple Bootable USB Drive Maker for Mac
#Author: ETCG (Epic Tin Can Games)

#Under MIT License:

#Copyright (c) 2016 ETCG
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#Variables:
ISOFILE="file.iso"
IMGFILE="file.img.dmg"
DIR="/tmp/etcg_drivemaker"
DISK="/dev/"
UBUNTU_VERSION="16.04.6"
DEBIAN_VERSION="9.9.0"

#Functions:
function downloadFile {
	sudo curl "$1" --output "$ISOFILE"
	if [ $? -eq 0 ]
	then
		echo "Download Successful."
	else
		echo "Download Failed."
		echo "Quiting...."
		exit 1
	fi
}
#Main:
echo
echo "To stop this script at any time, hit Control+C"
echo "Setting Up..."
sudo rm -r "$DIR" > /dev/null 2>&1 #Cleans up any old operations, to prevent any errors, and hides output
sudo mkdir "$DIR"
cd "$DIR"

echo
echo "OS Choices:"
echo "  (A) Ubuntu "$UBUNTU_VERSION
echo "  (B) Debian "$DEBIAN_VERSION
echo "  (C) Other          (You'll have to manually enter a URL)"
echo "  (D) Skip this step (You'll have to provide a path to the downloaded ISO.)"
echo "Please enter the letter corresponding with your choice (A, B, C, or D):"
read userOption

echo
if [ "$userOption" == "A" ]; then
	echo "Downloading Ubuntu..."
	if ! downloadFile "http://mirror.pnl.gov/releases/16.04/ubuntu-"$UBUNTU_VERSION"-desktop-amd64.iso"
	then
		exit 1
	fi
elif [ "$userOption" == "B" ]; then
	echo "Downloading Debian..."
	if ! downloadFile "https://caesar.ftp.acc.umu.se/debian-cd/current/amd64/iso-cd/debian-"$DEBIAN_VERSION"-amd64-netinst.iso"
	then
		exit 1
	fi
elif [ "$userOption" == "C" ]; then
	echo "Please enter the ISO's URL, including the .iso:"
	read DOWNLOADLINK
	echo "Downloading the OS..."
	if ! downloadFile "$DOWNLOADLINK"
	then
		exit 1
	fi
else
	echo "Please enter the ISO file's path (You can drag and drop the file here too):"
	read ISOPATH
	echo "Working..."
	cp "$ISOPATH" .
	ISOFILE="$(basename $ISOPATH)"	
fi

echo
echo "Converting the ISO to the needed format..."
if ! sudo hdiutil convert -format UDRW -o "$IMGFILE" "$ISOFILE"
then
	echo "Conversion Failed."
	echo "This is probably due to an invalid ISO file."
	echo "If you used option A or B, please email me at contact@etcg.pw so I can resolve the issue."
	echo "Quiting..."
	exit 2
else echo "Conversion Successful."
fi

echo
echo "Please enter your drive's label (open Disk Utility, select your drive, and locate the value right of \"Device:\"):"
read LABEL
DISK+=$LABEL

echo
echo "Unmounting Disk..."
if ! diskutil unmountDisk "$DISK"
then
	echo "Unmounting Failed."
	echo "Quiting..."
	exit 3
fi

echo
echo "About to make the bootable drive, this will erase all data on the drive"
echo "You have 20 seconds to abort (abort by hitting \"Control\" and \"C\" at the same time)..."
sleep 20

echo
echo "Making Bootable Drive (this will take a long time)..."
if sudo dd if="$IMGFILE" of="$DISK" bs=4m
then
	echo "+--------------+"
	echo "|Drive Created!|"
	echo "+--------------+"
	EXITSTATUS=0
else
	echo "+----------------+"
	echo "|Creation Failed!|"
	echo "+----------------+"
	EXITSTATUS=4
fi
echo "Cleaning Up..."
sudo rm -r "$DIR"
echo "Quiting..."
exit "$EXITSTATUS"
