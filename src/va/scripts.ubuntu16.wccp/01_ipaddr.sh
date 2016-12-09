#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# check kernel forwarding is enabled
enabled=`cat /proc/sys/net/ipv4/ip_forward`
if [[ $enabled -ne 1 ]]; then
    echo "Kernel forwarding seems to be disabled, enable it in /etc/sysctl.conf, reboot and rerun this script again"
    exit 1
fi

# set IP address to staticly allocated 192.168.1.15
cp interfaces /etc/network/interfaces

# and reboot
reboot