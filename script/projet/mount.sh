#!/bin/bash
apt update
apt install smbclient cifs-utils -y
mkdir -p /mnt/script
mkdir -p /mnt/partage
mount -t cifs //192.168.1.10/partage/ /mnt/partage -o username=Administrateur,password=P@ssw0rd
mount -t cifs //192.168.1.10/script$ /mnt/script -o username=Administrateur,password=P@ssw0rd
echo "le montage est fini"
