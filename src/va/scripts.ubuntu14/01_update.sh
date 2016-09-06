#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# update and upgrade
apt-get update && apt-get -y upgrade

# switch to the currentl security-supported stack
apt-get -y install linux-generic-lts-xenial linux-image-generic-lts-xenial

# and reboot
reboot