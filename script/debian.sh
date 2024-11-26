#!/bin/bash
wget https://mgrosmann.onrender.com/script/agent-glpi.sh
wget https://mgrosmann.onrender.com/script/deb_docker.sh
wget https://mgrosmann.onrender.com/script/glpi.sh
wget https://mgrosmann.onrender.com/script/nextcloud.sh
wget https://mgrosmann.onrender.com/script/rsync.sh
wget https://mgrosmann.onrender.com/script/promotheus.sh
wget https://mgrosmann.onrender.com/script/remove.sh
apt install sudo
chmod +x *.sh
bash deb_docker.sh
bash promotheus.sh
bash nextcloud.sh
