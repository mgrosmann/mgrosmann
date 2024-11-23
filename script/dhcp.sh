#!/bin/bash

# Nom de l'interface réseau (remplacez par le nom de votre interface, par exemple enp0s3)
INTERFACE="enp0s3"

# Mettre à jour les paquets et installer dhclient si nécessaire
sudo apt update
sudo apt install -y isc-dhcp-client

# Libérer l'ancienne adresse IP
sudo dhclient -r $INTERFACE

# Désactiver l'interface réseau
sudo ip link set $INTERFACE down

# Réactiver l'interface réseau
sudo ip link set $INTERFACE up

# Redémarrer le service réseau pour obtenir une nouvelle adresse IP
sudo systemctl restart systemd-networkd

# Obtenir une nouvelle adresse IP via DHCP
sudo dhclient $INTERFACE

# Afficher la nouvelle adresse IP
hostname -I
