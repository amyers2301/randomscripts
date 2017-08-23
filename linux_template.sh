#!/bin/bash

# Script to "sysprep" a CentOS-based VM to be converted to a template.
# Shamelessly taken from: https://lonesysadmin.net/2013/03/26/preparing-linux-template-vms/

# Install the following
# yum install -y vim open-vm-tools yum-utils
# yum update -y && reboot

# Run the scanner_add.sh script to add the scanning user.

service rsyslog stop
service auditd stop
package-cleanup --oldkernels --count=1 -y
yum clean all
logrotate -f /etc/logrotate.conf
rm -f /var/log/*-???????? /var/log/*.gz
rm -f /var/log/dmesg.old
rm -rf /var/log/anaconda
cat /dev/null > /var/log/audit/audit.log
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/grubby
rm -f /etc/udev/rules.d/70*
sed -i '/^UUID\|HWADDR\=/d' /etc/sysconfig/network-scripts/ifcfg-e*
rm -rf /tmp/*
rm -rf /var/tmp/*
rm -f /etc/ssh/*key*
rm -rf ~root/.ssh/
rm -f ~root/anaconda-ks.cfg
rm -f ~root/.bash_history
chage -d 0 root
rm -f /root/linux_template.sh

echo "Run the following manually:"
echo ""
echo "unset HISTFILE"
echo ""
