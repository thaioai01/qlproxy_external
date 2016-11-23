#!/bin/csh

# setup some configuration variables
ARCH=`uname -m`

DDWS_VERSION=4.8.0
DDWS_BUILD=E0DA

# get latest version of web safety
fetch http://packages.diladele.com/qlproxy/$DDWS_VERSION.$DDWS_BUILD/$ARCH/release/freebsd10/qlproxy-$DDWS_VERSION-$ARCH.txz

# and install it
env ASSUME_ALWAYS_YES=YES pkg install -y qlproxy-$DDWS_VERSION-$ARCH.txz

# autostart ICAP server
grep -e '^\s*qlproxyd_enable\s*=\s*\"YES\"\s*$' /etc/rc.conf
if [ $? -ne 0 ]; then
	echo "qlproxyd_enable=\"YES\"" >> /etc/rc.conf
fi

# autostart monitoring server
grep -e '^\s*wsmgrd_enable\s*=\s*\"YES\"\s*$' /etc/rc.conf
if [ $? -ne 0 ]; then
	echo "wsmgrd_enable=\"YES\"" >> /etc/rc.conf
fi
