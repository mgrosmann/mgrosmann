#!/bin/bash
wget https://mgrosmann.vercel.app/script/docker.sh
wget https://mgrosmann.vercel.app/script/glpi.sh
wget https://mgrosmann.vercel.app/script/nextcloud.sh
wget https://mgrosmann.vercel.app/script/promotheus.sh
wget https://mgrosmann.vercel.app/script/remove.sh
chmod +x docker.sh
chmod +x glpi.sh
chmod +x nextcloud.sh
chmod +x promotheus.sh
chmod +x remove.sh
bash docker.sh
bash glpi.sh
bash promotheus.sh
bash nextcloud.sh
