#!/bin/bash

# all web packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install required libs
#export DEBIAN_FRONTEND=noninteractive 
#apt-get -y install krb5-user nginx python-ldap python-pip

# install web safety requirements
#pip install -r /opt/websafety/var/console/requirements.txt

# add gunicorn service
cp gunicorn.service /etc/systemd/system/ 

# and enable it
systemctl start gunicorn
systemctl enable gunicorn

# copy the site to nginx
cp websafety.site /etc/nginx/sites-available

# disable default site
rm /etc/nginx/sites-enabled/default

# enable the site
ln -s /etc/nginx/sites-available/websafety.site /etc/nginx/sites-enabled

# ask nginx to check our site for syntax errors
nginx -t

# and restart nginx
systemctl restart nginx

# to have PDF reports we need to install reportlab with a lot of dependencies
#apt-get -y install python-dev libjpeg-dev zlib1g-dev

# now install reportlab
#pip install reportlab==3.3.0

# install apache and mod_wsgi
#apt-get -y install apache2 libapache2-mod-wsgi


