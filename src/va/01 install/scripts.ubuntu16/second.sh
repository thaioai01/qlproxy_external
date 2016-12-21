#!/bin/bash

# we must be root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# call all other steps
bash 02_web.sh && bash 03_squid.sh && bash 04_diladele.sh && bash 05_integrate.sh
