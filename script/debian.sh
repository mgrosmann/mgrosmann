#!/bin/bash
wget https://mgrosmann.vercel.app/script/deb_docker.sh
wget https://mgrosmann.vercel.app/script/edit.sh
wget https://mgrosmann.vercel.app/script/glpi.sh
wget https://mgrosmann.vercel.app/script/nextcloud.sh
wget https://mgrosmann.vercel.app/script/promotheus.sh
wget https://mgrosmann.vercel.app/script/remove.sh
chmod +x deb_docker.sh
chmod +x edit.sh
chmod +x glpi.sh
chmod +x nextcloud.sh
chmod +x promotheus.sh
chmod +x remove.sh
bash deb_docker.sh
bash glpi.sh
bash promotheus.sh
bash edit.sh nextcloud.sh nc.sh
bash nc.sh
