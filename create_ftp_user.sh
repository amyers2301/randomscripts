#!/bin/bash

## Creates a FTP user for INSIGHT DLP SecureFTP
programname=$0

function usage {
  echo ""
  echo "usage: $programname [user]"
  echo "" 
  echo "[user] is the user name of the client to login to the ftp server."
  echo "A password will be automatically generated."
}

if [ "$UID" -ne 0 ]
  then echo "Please run with root"
  exit
fi

if [ $# -le 0 ]; then
  usage
  exit 1
fi


useradd $1 -G ftp -s /sbin/nologin
randompwd=`dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev`
echo $randompwd | passwd --stdin $1
echo $1 " :: " $randompwd >> /home/support/userList
mkdir /home/$1/pub
mount -o bind /var/ftp/pub /home/$1/pub
echo "/var/ftp/pub            /home/$1/pub       none    bind    0 0" >> /etc/fstab

echo "$1 user created."
echo "password is: $randompwd"
