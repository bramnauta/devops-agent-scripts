#!/bin/bash

# Script by Bram Nauta

# Check if the script is running as root
if [ "$EUID" -eq 0 ]; then
  echo "This script must not be run as root. Exiting."
  exit 1
fi

read -p "Please enter the URL to the DevOps agent archive: " ARCHIVEURL
read -p "Please enter the URL to your DevOps organization: " DEVOPSURL
read -p "Please enter the name of your DevOps agent pool: " POOL
read -s -p "Please enter your PAT (not visible): " TOKEN
echo
read -p "Please enter the amount of agents to install: " AGENTCOUNT
read -p "Please enter the number of the first agent to install (usually 1): " AGENTSTARTID

wget -O /tmp/vsts-agent-linux-x64.tar.gz $ARCHIVEURL

cd /usr/bin
for AGENTID in $(seq -f "%03g" $AGENTSTARTID $(($AGENTCOUNT + $AGENTSTARTID - 1)))
do
  sudo mkdir -p agent$AGENTID
  sudo mkdir -p /var/vsts/agent$AGENTID/_work
  cd agent$AGENTID
  sudo tar zxvf /tmp/vsts-agent-linux-x64.tar.gz
  ./config.sh --url $DEVOPSURL --auth pat --token $TOKEN --unattended --pool $POOL --agent `hostname`-agent$AGENTID --work /var/vsts/agent$AGENTID/_work --acceptTeeEula
  sudo ./svc.sh install
  sudo ./svc.sh start
  cd ..
done

rm /tmp/vsts-agent-linux-x64.tar.gz
