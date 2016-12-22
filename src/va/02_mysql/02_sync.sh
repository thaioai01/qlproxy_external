#!/bin/bash

# we must be root to install packages
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# create special 'qlproxy' user in mysql with superuser rights
mysql -u root mysql < qlproxy.sql

# create the database (all mysql specific settings are taken from settings.py)
python /opt/qlproxy/var/console/switch_db.py --db=mysql

# generate the monitor.json in /opt/qlproxy/etc/ with new correct database settings
python /opt/qlproxy/var/console/sync_db.py

# reset the owner
chown -R qlproxy:qlproxy /opt/qlproxy

# restart django and wsmgrd
systemctl restart wsmgrd

if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]; then
	systemctl restart httpd
else 
	systemctl restart apache2
fi

