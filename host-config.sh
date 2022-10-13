#!/bin/bash

printf "Updating the enviroment\n"
###################################
# sudo password for sudo commands #
###################################

if [[ "$(/usr/bin/whoami)" != "root" ]]; then
sudo -p "The script needs the admin/sudo password to continue, please enter: " date 2>/dev/null 1>&2
        if [ ! $? = 0 ]; then
            echo "You entered an invalid password. Script aborted."
            exit 1
        fi
fi

####################################
# Operating System (Linux) upgrade #
####################################
read -p "Update Operating System (Linux)? (yes or [no]): " INPUT

case $INPUT in
  y|yes)
        echo "Updating Operating System (Linux)... please wait"
        sleep 3
        sudo apt-get update -y        # command is used to download package information from all configured sources.
        sudo apt-get upgrade -y       # You run sudo apt-get upgrade to install available upgrades of all packages currently installed on the system from the sources configured via sources. list file. New packages will be installed if required to satisfy dependencies, but existing packages will never be removed
        ;;
*)
        echo "Skipped! The software upgrade will continue without updating the Operating System... please wait"
        sleep 3
        ;;
esac

printf "Securing the enviroment\n"

printf "Synconizing with with NTP servers\n"

sudo apt-get install chrony -y
#Move the file to /etc/chrony/chrony.conf 
sudo cp chrony.conf /etc/chrony/chrony.conf
#Restart chrony in order for config change to take effect.
sudo systemctl restart chronyd.service

#To see the source of synchronization data.
# chronyc sources
#To view the current status of chrony.
# chronyc tracking


wget wget https://raw.githubusercontent.com/cardano-community/guild-operators/alpha/scripts/cnode-helper-scripts/prereqs.sh

chmod +x prereqs.sh

#install docker
printf "Installing Docker\n"

sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

printf "Installing Docker\n"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

docker version
docker compose version