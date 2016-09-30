#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# reset system root password to match documented one
sudo echo root:Passw0rd | sudo chpasswd

# now we allow root login for ssh
sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

# install vm tools (only if vmware is detected)
dmesg | grep -i "hypervisor detected: vmware" > /dev/null
if [ $? -eq 0 ]; then
    echo "Detected VMware, installing open-vm-tools..."
    if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]; then
        yum -y install open-vm-tools
        systemctl enable vmtoolsd.service && systemctl start vmtoolsd.service
    else
        apt-get update > /dev/null
        apt-get install -y open-vm-tools
    fi
fi

# copy the /etc/issue creation script to qlproxy folder
cp va_issue.sh /opt/qlproxy/bin/

# now setup /etc/issue login banner
if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]
then
    # we are on centos 7 - just run the script (IP address will not be automatically updated)
    /bin/bash /opt/qlproxy/bin/va_issue.sh > /etc/issue    
else
    # we are on ubuntu - create a system wide interface up script
    cp ubuntu14/issue_update /etc/network/if-up.d/issue_update

    # and make it executable
    chmod +x /etc/network/if-up.d/issue_update
fi

# disable the user we used to build the virtual appliance
passwd user -l

# exit successfully
echo "VA generated successfully, please reboot"
