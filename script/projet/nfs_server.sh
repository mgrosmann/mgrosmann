#!/bin/bash
apt update
apt install nfs-kernel-server
mkdir /mnt/NFS-BACKUP
chown nobody:nogroup /mnt/NFS-BACKUP
chmod 777 /mnt/NFS-BACKUP
exportfs -a
systemctl restart nfs-kernel-server
