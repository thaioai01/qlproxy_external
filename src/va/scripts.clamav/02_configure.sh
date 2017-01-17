#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# patch /etc/default/c-icap (make c-icap autostart)
if [ ! -f /etc/default/c-icap.default ]; then
    cp -f /etc/default/c-icap /etc/default/c-icap.default
fi
patch /etc/default/c-icap < c-icap.patch

# patch settings in c-icap.conf
if [ ! -f /etc/c-icap/c-icap.conf.default ]; then
    cp -f /etc/c-icap/c-icap.conf c-icap/c-icap.conf.default
fi
patch /etc/c-icap/c-icap.conf < c-icap.conf.patch


# stop immediately on any error
set -e


# in /etc/c-icap/c-icap.conf change
#   Service squidclamav squidclamav.so

# in /etc/c-icap/squidclamav.conf change (for example redirect to google when virus is found)
# redirect http://www.google.com

# download EICAR file to test if it works
# wget http://www.eicar.org/download/eicar.com

# scan the current folder (it should output "Eicar-Test-Signature FOUND" message)
# clamscan

# restart
# systemctl stop c-icap
# systemctl start c-icap

# check status (must be running)
# systemctl status c-icap

# in Web UI / Squid / ICAP / Experimental Chain [X] Enable Antivirus
# fill ICAP REQMOD Path and ICAP RESPMOD Path as "squidclamav" (without quotes)

# run
# systemctl restart c-icap

# run Save and Restart from Web UI
