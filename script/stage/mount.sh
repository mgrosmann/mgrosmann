#!/bin/bash
apt update
if ! command -v smbclient &> /dev/null
then
    echo "smbclient n'est pas installé. Installation en cours..."
    sudo apt-get update
    sudo apt-get install -y smbclient
else
    echo "smbclient est déjà installé."
fi
if ! command -v cifs-utils &> /dev/null
then
    echo "cifs-utils n'est pas installé. Installation en cours..."
    sudo apt-get update
    sudo apt-get install -y cifs-utils
else
    echo "cifs-utils est déjà installé."
fi
mkdir -p /mnt/video
mkdir -p /mnt/photo
sudo mount -t cifs //192.168.1.32/travail/bande\ annonce\ affichage\ magasin/ /mnt/video -o username=test,password=test
sudo mount -t cifs //192.168.1.32/travail/Morgoth/fond\ d\'ecran/ /mnt/photo -o username=test,password=test
echo "le montage est fini"
#smbclient //192.168.1.32/travail -U test
mount -t cifs //192.168.1.17/backup/bande\ annonce\ affichage\ magasin/ /mnt/backup -o username=test,password=test