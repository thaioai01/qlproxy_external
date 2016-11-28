#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install build tools
apt-get -y install devscripts build-essential fakeroot debhelper dh-autoreconf cdbs

# install build dependences for squid
apt-get -y build-dep squid3

# install additional packages for new squid
apt-get -y install libdbi-perl libssl-dev