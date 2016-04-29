#!/bin/bash

# v1.0
# Adds new ILT user to list of users able to run create and remove.
# Also will create symlinks for the files necessary into their home
# directory.

## Adds ILT user's information to system for login and FTP user add
programname=$0

function usage {
  echo ""
  echo "usage: $programname [user]"
  echo "" 
  echo "[user] is the user name of the ILT user to login to the ftp server."
  echo "Prior to running this, have the public portion of the ssh key available"
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
useradd $1 -G ilt

# Add symlinks to user's home directory
ln -s /etc/ftp/README.txt /home/$1/README
ln -s /etc/ftp/userList /home/$1/userList
ln -s /etc/ftp/create_ftp_user.sh /home/$1/create.sh
ln -s /etc/ftp/remove_ftp_user.sh /home/$1/remove.sh

# Create ssh directory
mkdir /home/$1/.ssh
touch /home/$1/.ssh/authorized_keys

# Set permissions
chmod 700 /home/$1/.ssh
chmod 600 /home/$1/.ssh/authorized_keys
chown -R $1:$1 /home/$1/*

# Provide feedback of success (not like we're checking for failure)
echo "$1 user created."
echo "Remember to add the private key to /home/$1/.ssh/authorized_keys"

