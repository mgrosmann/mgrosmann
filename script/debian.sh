#!/bin/bash
wget https://mgrosmann.onrender.com/agent-glpi.sh
wget https://mgrosmann.onrender.com/deb_docker.sh
wget https://mgrosmann.onrender.com/glpi.sh
wget https://mgrosmann.onrender.com/nextcloud.sh
wget https://mgrosmann.onrender.com/rsync.sh
wget https://mgrosmann.onrender.com/promotheus.sh
wget https://mgrosmann.onrender.com/remove.sh
apt install sudo
chmod +x *.sh
bash deb_docker.sh
bash promotheus.sh
bash nextcloud.sh
