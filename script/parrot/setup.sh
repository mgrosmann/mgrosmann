#!/bin/bash
wget https://mgrosmann.vercel.app/script/parrot/docker.sh
wget https://mgrosmann.vercel.app/script/parrot/edit.sh
wget https://mgrosmann.vercel.app/script/parrot/glpi.sh
wget https://mgrosmann.vercel.app/script/parrot/nextcloud.sh
wget https://mgrosmann.vercel.app/script/parrot/promotheus.sh
wget https://mgrosmann.vercel.app/script/remove.sh
chmod +x docker.sh
chmod +x edit.sh
chmod +x glpi.sh
chmod +x nextcloud.sh
chmod +x promotheus.sh
chmod +x remove.sh
bash docker.sh
bash glpi.sh
bash promotheus.sh
bash edit.sh nextcloud.sh nc.sh
bash nc.sh
