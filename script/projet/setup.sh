#!/bin/bash
wget https://mgrosmann.onrender.com/script/projet/agent-glpi.sh
wget https://mgrosmann.onrender.com/script/projet/docker.sh
wget https://mgrosmann.onrender.com/script/projet/glpi.sh
wget https://mgrosmann.onrender.com/script/projet/nextcloud.sh
wget https://mgrosmann.onrender.com/script/projet/zabbix.sh
wget https://mgrosmann.onrender.com/script/projet/veeam.sh
chmod +x *.sh
bash glpi.sh
bash docker.sh
bash zabbix.sh
bash nextcloud.sh
bash veeam.sh
