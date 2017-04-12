#!/bin/bash

# install RPMs as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# enable epel repository
yum -y install epel-release

# add squid repository
cp squid.repo /etc/yum.repos.d

# update
yum -y update

# install required perl module
yum -y install perl-Crypt-OpenSSL-X509

# and squid modules
yum -y install libecap squid squid-helpers

# make squid autostart after reboot
systemctl enable squid.service