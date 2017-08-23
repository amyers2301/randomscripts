#!/bin/bash
#####
## Remove SSH keys which already exist
## because testing servers
## Version 1.2

## Usage
[ $# -eq 0 ] && { echo -e "Usage: `basename $0` <IP_address> or <host_name> [-y]"; echo "example: `basename $0` 192.168.4.22"; exit 1; }

## Delete
hostsPath=~/.ssh/known_hosts
found=$(grep -Fw $1 $hostsPath)

if [[ -n "$found" ]]; then
    if [[ $2 == "y" || $2 == "Y" ]]; then
        sed -i "\%$1%d" $hostsPath 
        echo "Entry deleted." 
        exit 0
    else
        echo -e "$found\nAre you sure you want to remove this entry? "
        read continue
        if [[ $continue == "Y" || $continue == "y" ]]; then
            sed -i "\%$1%d" $hostsPath
            echo "Entry deleted."
        else
            echo "No changes made. Exiting..."
        fi
    fi
else
    echo "$1 doesn't exist in $hostsPath"
fi
