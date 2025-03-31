#!/bin/bash

# Script by Bram Nauta

# Loop through all directories in /usr/bin that match the pattern agentXXX
for dir in /usr/bin/agent[0-9][0-9][0-9]; do
  # Check if the directory exists and contains svc.sh
  if [ -d "$dir" ] && [ -f "$dir/svc.sh" ]; then
    cd $dir
    sudo ./svc.sh stop
    sudo ./svc.sh start
  fi
done
