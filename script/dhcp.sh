#!/bin/bash
INTERFACE="enp0s3"
sudo apt update
sudo apt install isc-dhcp-client
# Libérer l'ancienne adresse IP
sudo dhclient -r $INTERFACE

# Redémarrer le service réseau pour obtenir une nouvelle adresse IP
sudo systemctl restart systemd-networkd

# Obtenir une nouvelle adresse IP via DHCP
sudo dhclient $INTERFACE

# Afficher la nouvelle adresse IP
hostname -I
