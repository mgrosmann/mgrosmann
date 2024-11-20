#!/bin/bash
wget https://mgrosmann.vercel.app/script/caca.sh
wget https://mgrosmann.vercel.app/script/deb_docker.sh
wget https://mgrosmann.vercel.app/script/edit.sh
wget https://mgrosmann.vercel.app/script/flemme.sh
wget https://mgrosmann.vercel.app/script/fvcknextcloud.sh
wget https://mgrosmann.vercel.app/script/glpi.sh
wget https://mgrosmann.vercel.app/script/nextcloud.sh
wget https://mgrosmann.vercel.app/script/nikphp.sh
wget https://mgrosmann.vercel.app/script/promotheus.sh
wget https://mgrosmann.vercel.app/script/remove.sh
wget https://mgrosmann.vercel.app/script/rsync.sh
wget https://mgrosmann.vercel.app/script/test.sh
wget https://mgrosmann.vercel.app/script/uninstall.sh
wget https://mgrosmann.vercel.app/script/update_php_8.1.sh
chmod +x caca.sh
chmod +x deb_docker.sh
chmod +x edit.sh
chmod +x flemme.sh
chmod +x fvcknextcloud.sh
chmod +x glpi.sh
chmod +x nextcloud.sh
chmod +x nikphp.sh
chmod +x promotheus.sh
chmod +x remove.sh
chmod +x rsync.sh
chmod +x test.sh
chmod +x uninstall.sh
chmod +x update_php_8.1.sh
apt install sudo
bash deb_docker.sh
bash glpi.sh
bash promotheus.sh
bash edit.sh nextcloud.sh nc.sh
bash nc.sh
