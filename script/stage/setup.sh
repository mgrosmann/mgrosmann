#!/bin/bash
systemctl restart minidlna.service
mount -t cifs //192.168.1.32/travail/ /mnt/travail -o username=test,password=test
mount -t cifs //192.168.1.32/travail/bande\ annonce\ affichage\ magasin/ /mnt/video -o username=test,password=test
mount -t cifs //192.168.1.32/travail/Morgoth/fond\ d\'ecran/ /mnt/photo -o username=test,password=test
mount -t cifs //192.168.1.17/backup /mnt/backup -o username=test,password=test