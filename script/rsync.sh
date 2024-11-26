#!/bin/bash

echo "Installation de rsync..."
sudo apt update
sudo apt install -y rsync

# Créer les répertoires nécessaires
mkdir -p /home/mgrosmann/backup
mkdir -p /home/mgrosmann/desktop
mkdir -p /home/mgrosmann/save
wget https://mgrosmann.onrender.com/script/mysql.sh
wget https://mgrosmann.onrender.com/script/mysql_dump.sh
wget https://mgrosmann.onrender.com/script/save.sh
wget https://mgrosmann.onrender.com/script/backup.sh
chmod +x mysql.sh
chmod +x mysql_dump.sh
chmod +x save.sh
chmod +x backup.sh
bash mysql.sh
bash mysql_dump.sh
echo "installation finalisée, n'oubliez pas de modifier les fichiers save.sh et backup.sh afin de définir l'adresse ip et le user de la machine distante qui servira a stocker les sauvegarde et les restaurer"
