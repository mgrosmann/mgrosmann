#!/bin/bash
wget https://mgrosmann.onrender.com/script/projet/agent-glpi.sh
wget https://mgrosmann.onrender.com/script/projet/docker.sh
wget https://mgrosmann.onrender.com/script/projet/glpi.sh
wget https://mgrosmann.onrender.com/script/projet/nextcloud.sh
wget https://mgrosmann.onrender.com/script/projet/promotheus.sh
wget https://mgrosmann.onrender.com/script/projet/rsync.sh
wget https://mgrosmann.onrender.com/script/projet/remove.sh
chmod +x *.sh
bash glpi.sh
bash docker.sh
bash promotheus.sh
bash nextcloud.sh
bash rsync.sh
