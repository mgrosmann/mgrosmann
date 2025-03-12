#!/bin/bash
server=
folder=
apt update
apt install nfs-common
mkdir /var/locally-mounted/
sudo mount -t nfs $server:$folder /var/locally-mounted
