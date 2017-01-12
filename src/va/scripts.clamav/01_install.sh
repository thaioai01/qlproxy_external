# install clamav
apt-get -y install clamav
apt-get -y install clamav-daemon 

# download EICAR file to test if it works
wget http://www.eicar.org/download/eicar.com

# scan the current folder (it should output "Eicar-Test-Signature FOUND" message)
clamscan

# install c-icap
apt-get -y install c-icap
apt-get -y install libicapapi-dev

# in /etc/default/c-icap change
#   start=YES

# in /etc/c-icap/c-icap.conf change
#	Port 1345
#   Service squidclamav squidclamav.so
#   ModulesDir /usr/lib/x86_64-linux-gnu/c_icap
#   ServicesDir /usr/lib/x86_64-linux-gnu/c_icap


# install squidclamav
cd ~
mkdir squidclamav
cd squidclamav
wget http://downloads.sourceforge.net/project/squidclamav/squidclamav/6.16/squidclamav-6.16.tar.gz
gunzip squidclamav-6.16.tar.gz
tar -xvf squidclamav-6.16.tar.gz

cd squidclamav-6.16

./configure --with-c-icap=/usr
make
make install

# in /etc/c-icap/squidclamav.conf change (for example redirect to google when virus is found)
redirect http://www.google.com

# restart
systemctl stop c-icap
systemctl start c-icap

# check status (must be running)
systemctl status c-icap

# in Web UI / Squid / ICAP / Experimental Chain [X] Enable Antivirus
# fill ICAP REQMOD Path and ICAP RESPMOD Path as "squidclamav" (without quotes)

# run
systemctl restart c-icap

# run Save and Restart from Web UI
