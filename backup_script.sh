#!/bin/bash

#Make Sure the user entered 2 arguments
if [ $# -ne 2 ]
then
  echo "Usage: backup_script.sh <source directory> <backup directory>"
  echo "Please try again"
  exit 1
fi

#Check if rsync is installed

if ! command -v rsync > /dev/null 2>&1
then
  echo "This Script requires rsync to be installed, installing it... "
  release_name=/etc/os-release

  if grep -q "Red" $release_name || grep -q "red" $release_name
  then
    dst_pckg=yum
  fi

  if grep -q "ubuntu" $release_name || grep -q "Ubuntu" $release_name
  then
    dst_pckg=apt
  fi

  sudo $dst_pckg install -y rsync 1>/dev/null 2>pckg_installation_error.log
  if [ $? -ne 0 ]
  then
    echo "rsync installation failed"
    exit 2
  fi
fi

#Capture the current date, and store it in a format YYYY-MM-DD
current_date=$(date +%y-%m-%d)
rsync_options="-avb --backup-dir $2/$current_date --delete"
$(which rsync) $rsync_options $1 $2/current >>backup_$current_date.log

