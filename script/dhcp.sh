#!/bin/bash

# Nom de l'interface réseau (remplacez par le nom de votre interface, par exemple eth0 ou ens33)
INTERFACE="eth0"

# Libérer l'ancienne adresse IP
sudo dhclient -r $INTERFACE

# Redémarrer le service réseau pour obtenir une nouvelle adresse IP
sudo systemctl restart systemd-networkd

# Obtenir une nouvelle adresse IP via DHCP
sudo dhclient $INTERFACE

# Afficher la nouvelle adresse IP
hostname -I
