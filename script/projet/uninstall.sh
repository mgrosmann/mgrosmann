#!/bin/bash

# Désinstallation de rsync
echo "Désinstallation de rsync..."
sudo apt-get remove --purge -y rsync
sudo apt-get autoremove -y
sudo apt-get clean

# Désinstallation de Prometheus
echo "Désinstallation de Prometheus..."
sudo systemctl stop prometheus
sudo systemctl disable prometheus
sudo apt-get remove --purge -y prometheus
sudo apt-get autoremove -y
sudo apt-get clean

# Désinstallation de GLPI
echo "Désinstallation de GLPI..."
sudo systemctl stop glpi
sudo systemctl disable glpi
sudo apt-get remove --purge -y glpi
sudo apt-get autoremove -y
sudo apt-get clean

# Désinstallation de Docker
echo "Désinstallation de Docker..."
sudo systemctl stop docker
sudo systemctl disable docker
sudo apt-get remove --purge -y docker docker-engine docker.io containerd runc
sudo apt-get autoremove -y
sudo apt-get clean

echo "Tous les services ont été désinstallés avec succès."

