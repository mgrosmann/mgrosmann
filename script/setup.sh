#!/bin/bash
wget https://mgrosmann.onrender.com/agent-glpi.sh
wget https://mgrosmann.onrender.com/docker.sh
wget https://mgrosmann.onrender.com/glpi.sh
wget https://mgrosmann.onrender.com/nextcloud.sh
wget https://mgrosmann.onrender.com/promotheus.sh
wget https://mgrosmann.onrender.com/rsync.sh
wget https://mgrosmann.onrender.com/remove.sh
chmod +x *.sh
bash docker.sh
bash promotheus.sh
bash nextcloud.sh
