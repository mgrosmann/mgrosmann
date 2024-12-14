#!/bin/bash
sudo apt update
sudo apt install -y rsync
mkdir -p /home/mgrosmann/backup
mkdir -p /home/mgrosmann/desktop
mkdir -p /home/mgrosmann/save
wget https://mgrosmann.onrender.com/script/save.sh
wget https://mgrosmann.onrender.com/script/backup.sh
chmod +x save.sh
chmod +x backup.sh
