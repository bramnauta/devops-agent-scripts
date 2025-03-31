#!/bin/bash

# Script by Bram Nauta

# Loop through each directory in /usr/bin that matches the pattern agentXXX
for dir in /usr/bin/agent[0-9][0-9][0-9]; do
  # Check if the directory exists
  if [ -d "$dir" ]; then
    # Extract the username from the directory name
    agentname=$(basename "$dir")

    # Go into the directory
    cd "$dir" || exit

    # Call ./svc.sh uninstall
    if [ -f "./svc.sh" ]; then
      sudo ./svc.sh uninstall
    else
      echo "WARNING: svc.sh not found in $dir"
    fi

    # Go out of the directory
    cd ..

    # Remove the directory
    sudo rm -rf "$dir"

    # Delete the user non-interactively, ignore if the user doesn't exist
    if id "$agentname" &>/dev/null; then
      sudo userdel -r "$agentname"
    else
      echo "WARNING: User $agentname does not exist"
    fi

    sudo rm -rf "/var/vsts/$agentname"
  fi
done
