#!/bin/bash

# v1.2
# Removes FTP user from the FTP server. Also tries to remove the user
# from the saved user list

## Attempts to cleanly remove a FTP user for INSIGHT DLP SecureFTP
programname=$0
default=n

function usage {
  echo ""
  echo "usage: $programname [user]"
  echo ""
  echo "[user] is the user name of the client to delete from the ftp server."
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

# Look for the user provided by input & verify it's the right one
echo -ne "\nI've found \e[00;31m$1\e[00m in /home. \r
Are you sure you want to delete?: [$default] "
read continueUpdate

# If input is true, unmount pub, remove from /etc/fstab, remove from userList, and delete user from system
if [ "`echo $continueUpdate | grep -i ^y`" ]; then
  umount /home/$1/pub
  sed -i "\/home\/$1\/pub/d" /etc/fstab
  egrep -vw "$1" /etc/ftp/userList > /etc/ftp/userList2; mv -f /etc/ftp/userList2 /etc/ftp/userList
  userdel -r $1
  echo "$1 user deleted."
else
  echo "Not deleting $1. Exiting."
fi