#!/bin/bash

# Script for adding the inventory scanning user (scanner) to Linux systems in the ILT environment
# Takes $1 as the IP/hostname of the system to remote into. This will be an interactive login

hostsPath=~/.ssh/known_hosts
found=$(grep -Fw $1 $hostsPath)
host=${1##*@}

if ping -c 1 $host &> /dev/null; then
    if [[ ! -n "$found" ]]; then
        ssh-keyscan -t rsa $1 >> /home/amyers/.ssh/known_hosts
        ssh-copy-id root@$host
        ssh root@$host "useradd scanner; mkdir /home/scanner/.ssh; "
        scp /home/amyers/id_rsa_scanner.pub root@$host:/home/scanner/.ssh
        ssh root@$host "cat /home/scanner/.ssh/id_rsa_scanner.pub > /home/scanner/.ssh/authorized_keys; chown scanner:scanner -R /home/scanner/.ssh; chmod 600 /home/scanner/.ssh/authorized_keys; chmod 700 /home/scanner/.ssh"
    else
        ssh root@$host "useradd scanner; mkdir /home/scanner/.ssh; "
        scp /home/amyers/id_rsa_scanner.pub root@$host:/home/scanner/.ssh
        ssh root@$host "cat /home/scanner/.ssh/id_rsa_scanner.pub > /home/scanner/.ssh/authorized_keys; chown scanner:scanner -R /home/scanner/.ssh; chmod 600 /home/scanner/.ssh/authorized_keys; chmod 700 /home/scanner/.ssh"
    fi
else
    echo $host" appears to be down."
    exit
fi
