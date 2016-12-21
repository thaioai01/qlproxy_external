#!/bin/bash

# we must be root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# call step 1
bash 01_update.sh
