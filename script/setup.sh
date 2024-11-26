#!/bin/bash
wget https://mgrosmann.onrender.com/script/agent-glpi.sh
wget https://mgrosmann.onrender.com/script/docker.sh
wget https://mgrosmann.onrender.com/script/glpi.sh
wget https://mgrosmann.onrender.com/script/nextcloud.sh
wget https://mgrosmann.onrender.com/script/promotheus.sh
wget https://mgrosmann.onrender.com/script/rsync.sh
wget https://mgrosmann.onrender.com/script/remove.sh
chmod +x *.sh
bash docker.sh
bash promotheus.sh
bash nextcloud.sh
