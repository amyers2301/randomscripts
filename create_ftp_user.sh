#!/bin/bash

# v1.2
# Attempts to add a new user to the FTP. It adds the user name
# and password to a text file for reference later.

## Creates a FTP user for INSIGHT DLP SecureFTP
programname=$0

function usage {
  echo ""
  echo "usage: $programname [user]"
  echo "" 
  echo "[user] is the user name of the client to login to the ftp server."
  echo "A password will be automatically generated."
}

# Check for running as root since we need to be root to change /etc/fstab
if [ "$UID" -ne 0 ]
  then echo "Please run with root"
  exit
fi

# Check for program variables. If not provided, print usage and exit
if [ $# -le 0 ]; then
  usage
  exit 1
fi

# Add new user to GTP group with a nologin shell
useradd $1 -G ftp -s /sbin/nologin
#randompwd=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-35};echo;`
randompwd=`dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev`
# Set user password to random string then put it in the userList file
echo $randompwd | passwd --stdin $1
echo $1 " :: " $randompwd >> /etc/ftp/userList
# Create the public directory in the user's home, mount it, then update /etc/fstab
mkdir /home/$1/pub
mount -o bind /var/ftp/pub /home/$1/pub
echo "/var/ftp/pub            /home/$1/pub       none    bind    0 0" >> /etc/fstab

# Provide feedback of success (not like we're checking for failure)
echo "$1 user created."
echo "password is: $randompwd"

