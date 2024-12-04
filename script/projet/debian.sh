#!/bin/bash
wget https://mgrosmann.onrender.com/script/projet/agent-glpi.sh
wget https://mgrosmann.onrender.com/script/projet/deb_docker.sh
wget https://mgrosmann.onrender.com/script/projet/glpi.sh
wget https://mgrosmann.onrender.com/script/projet/nextcloud.sh
wget https://mgrosmann.onrender.com/script/projet/rsync.sh
wget https://mgrosmann.onrender.com/script/projet/promotheus.sh
wget https://mgrosmann.onrender.com/script/projet/remove.sh
apt install sudo
chmod +x *.sh
bash deb_docker.sh
bash promotheus.sh
bash nextcloud.sh
