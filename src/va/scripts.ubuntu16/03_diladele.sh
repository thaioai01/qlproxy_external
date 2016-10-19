#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="5.0.0"
MINOR="77D5"
ARCH="amd64"

# get latest package
wget http://packages.diladele.com/websafety/$MAJOR.$MINOR/$ARCH/release/ubuntu16/websafety-$MAJOR.${MINOR}_$ARCH.deb

# install it
dpkg --install websafety-$MAJOR.${MINOR}_$ARCH.deb
