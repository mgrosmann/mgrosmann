#!/bin/bash
apt update
apt install smbclient cifs-utils -y
mkdir -p /mnt/video
mkdir -p /mnt/photo
mkdir -p /mnt/travail
mkdir -p /mnt/backup
mount -t cifs //192.168.1.32/travail/ /mnt/travail -o username=test,password=test
mount -t cifs //192.168.1.32/travail/bande\ annonce\ affichage\ magasin/ /mnt/video -o username=test,password=test
mount -t cifs //192.168.1.32/travail/Morgoth/fond\ d\'ecran/ /mnt/photo -o username=test,password=test
mount -t cifs //192.168.1.100/backup /mnt/backup -o username=test,password=test
echo "le montage est fini"