#!/bin/bash
wget https://mgrosmann.vercel.app/script/agent-glpi.sh
wget https://mgrosmann.vercel.app/script/docker.sh
wget https://mgrosmann.vercel.app/script/glpi.sh
wget https://mgrosmann.vercel.app/script/mysql.sh
wget https://mgrosmann.vercel.app/script/mysql_dump.sh
wget https://mgrosmann.vercel.app/script/nextcloud.sh
wget https://mgrosmann.vercel.app/script/promotheus.sh
wget https://mgrosmann.vercel.app/script/rsync.sh
wget https://mgrosmann.vercel.app/script/save.sh
wget https://mgrosmann.vercel.app/script/backup.sh
wget https://mgrosmann.vercel.app/script/remove.sh
chmod +x agent-glpi.sh
chmod +x docker.sh
chmod +x glpi.sh
chmod +x mysql.sh
chmod +x save_db.sh
chmod +x nextcloud.sh
chmod +x promotheus.sh
chmod +x rsync.sh
chmod +x mysql_dump.sh
chmod +x save.sh
chmod +x backup.sh
chmod +x remove.sh
bash docker.sh
bash promotheus.sh
bash nextcloud.sh
bash mysql.sh
bash save_db.sh
