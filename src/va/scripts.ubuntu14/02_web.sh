#!/bin/bash

# all web packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# stop in case of any error
set -e

# install required python libs
apt-get -y install python-ldap python-pip

# install django
pip install django==1.6.11

# to have PDF reports we need to install reportlab with a lot of dependencies
apt-get -y install python-dev libjpeg-dev zlib1g-dev

# now install reportlab
pip install reportlab==3.3.0

# install apache and mod_wsgi
apt-get -y install apache2 libapache2-mod-wsgi

# install kerberos client libraries
export DEBIAN_FRONTEND=noninteractive 
apt-get -y install krb5-user

# sometimes the check-new-release process on Ubuntu eats all CPU, so we switch it to manual
sed -i "s/Prompt=lts/Prompt=never/g" /etc/update-manager/release-upgrades

# switch to the current security-supported stack
apt-get -y install linux-image-generic-lts-xenial linux-generic-lts-xenial && reboot
