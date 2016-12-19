#!/bin/bash

# iptables modifications are done by root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# RP filter does spoof protection - is it ON by default???
# sudo echo 0 >/proc/sys/net/ipv4/conf/gre1/rp_filter
# sudo echo 0 >/proc/sys/net/ipv4/conf/ens160/rp_filter

# set the default policy to accept first
iptables -P INPUT ACCEPT
 
# flush all current rules from iptables
iptables -F
 
# allow pings
# iptables -A INPUT -p icmp -j ACCEPT
 
# allow access for localhost
# iptables -A INPUT -i lo -j ACCEPT
 
# accept packets belonging to established and related connections
# iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
 
# allow ssh connections to tcp port 22
# iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# redirect incoming GRE tunnel to local Squid port
iptables -t nat -A PREROUTING -i gre1 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.1.15:3128


# ??????
# TODO?? - may it be the '-A PREROUTING -i gre1 -p tcp -m tcp -j REDIRECT --to-ports 3128' is better?
# ??????

                
# allow connection from LAN to ports 3126, 3127 and 3128 squid is running on
# iptables -A INPUT -i eth0 -p tcp --dport 3126 -j ACCEPT
# iptables -A INPUT -i eth0 -p tcp --dport 3127 -j ACCEPT
# iptables -A INPUT -i eth0 -p tcp --dport 3128 -j ACCEPT

# redirect all HTTP(tcp:80) traffic coming in through eth0 to 3126
# iptables -t nat -A PREROUTING -i eth0 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3126
 
# redirect all HTTPS(tcp:443) traffic coming in through eth0 to 3127
# iptables -t nat -A PREROUTING -i eth0 -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 3127
 
# configure forwarding rules
# iptables -A FORWARD -i eth0 -o eth1 -p tcp --dport 22 -j ACCEPT
# iptables -A FORWARD -i eth1 -o eth0 -p tcp --sport 22 -j ACCEPT
# iptables -A FORWARD -p icmp -j ACCEPT
# iptables -A FORWARD -i eth0 -o eth1 -p tcp --dport 80 -j ACCEPT
# iptables -A FORWARD -i eth1 -o eth0 -p tcp --sport 80 -j ACCEPT
# iptables -A FORWARD -i eth0 -o eth1 -p tcp --dport 53 -j ACCEPT
# iptables -A FORWARD -i eth0 -o eth1 -p udp --dport 53 -j ACCEPT
# iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited
 
# enable NAT for clients within LAN
# iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
 
# set default policies for INPUT, FORWARD (drop) and OUTPUT (accept) chains
# iptables -P INPUT DROP
# iptables -P FORWARD DROP
# iptables -P OUTPUT ACCEPT
 
# list created rules
iptables -L -v
 
# save the rules so that after reboot they are automatically restored
# /sbin/service iptables save
 
# enable the firewall
# chkconfig iptables on
 
# and reboot machine
# reboot