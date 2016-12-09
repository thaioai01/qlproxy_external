#!/bin/bash

# we setup GRE tunnels as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# first find out the Router ID address; this address will be used by Cisco when sending GRE
# encapsulated data from ASA to Squid boxes..

#
# in our case it is 192.168.178.10 <- i.e. IP address of the EXTERNAL Cisco interface.
# We need to read how to configure the PREDSKAZUEMII ADRESS!!!
#

# add gre tunnel
ip tunnel show
ip tunnel add wccp0 mode gre remote 192.168.1.10 local 192.168.1.15 dev enp2s0 ttl 255

ip tunnel add wccp0 mode gre remote 192.168.178.10 local 192.168.1.51 dev eth0 ttl 255

ip addr add 192.168.1.15 dev wccp0
ip link set wccp0 up

ip tunnel del wccp0

# trouble shoot
# tcpdump -npi enp2s0 ip proto 47 

# enable forwarding of packets in the kernel
echo 1 > /proc/sys/net/ipv4/ip_forward

# disable ip spoofing protection
echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/enp2s0/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/wccp0/rp_filter

# not needed???
echo 0 > /proc/sys/net/ipv4/conf/gre0/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/gretap0/rp_filter

# and redirect

# does not work
iptables -F
iptables -I INPUT -j ACCEPT
iptables -t nat -F
iptables -t nat -A PREROUTING -i wccp0 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.1.15:3128

iptables -t nat -A PREROUTING -i wccp0 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.1.51:3128

iptables -t nat -A PREROUTING -i wccp0 -p tcp -m tcp --dport 80 -j REDIRECT --to-port 3128


tcpdump –npi eth0 ip proto 47 
#C




# add tunnel


# ?????
# TODO? do we need to assing IP addresses for GRE tunnel interface? or referencing 'dev ens160' as above is enough??
# ?????

# and bring it up
# ip link set gre1 up 
