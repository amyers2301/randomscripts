#!/bin/bash

## Attempts to cleanly remove a FTP user for INSIGHT DLP SecureFTP
default=n

function usage {
  echo ""
  echo "usage: $0 [user]"
  echo ""
  echo "[user] is the user name of the client to delete from the ftp server."
}

if [ "$UID" -ne 0 ]
  then echo "Please run with root"
  exit
fi

if [ $# -le 0 ]; then
  usage
  exit 1
fi

echo -ne "\nI've found \e[00;31m$1\e[00m in /home. \r
Are you sure you want to delete?: [$default] "
read continueUpdate

if [ "`echo $continueUpdate | grep -i ^y`" ]; then
  umount /home/$1/pub
  sed -i "\/home\/$1\/pub/d" /etc/fstab
  egrep -vw "$1" /home/support/userList > /home/support/userList2; mv -f /home/support/userList2 /home/support/userList
  userdel -r $1
  echo "$1 user deleted."
else
  echo "Not deleting $1. Exiting."
fi
