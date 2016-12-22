#!/bin/bash

# we must be root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# call all steps
bash 01_mysql.sh && bash 02_sync.sh && bash 03_login.sh
