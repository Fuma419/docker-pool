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


wget wget https://raw.githubusercontent.com/cardano-community/guild-operators/alpha/scripts/cnode-helper-scripts/prereqs.sh

chmod +x prereqs.sh

