#!/bin/bash

echo "Installation de rsync..."
sudo apt update
sudo apt install -y rsync

# Créer les répertoires nécessaires
mkdir -p /home/mgrosmann/backup
mkdir -p /home/mgrosmann/desktop
mkdir -p /home/mgrosmann/save
