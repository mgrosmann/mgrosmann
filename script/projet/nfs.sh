#!/bin/bash
sudo apt-get update
sudo apt install nfs-kernel-server
sudo mkdir /mnt/NFS-BACKUP
sudo chown nobody:nogroup /mnt/NFS-BACKUP
sudo chmod 777 /mnt/NFS-BACKUP
