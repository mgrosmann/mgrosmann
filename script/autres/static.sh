#!/bin/bash

# Nom de l'interface réseau (remplacez par le nom de votre interface, par exemple enp0s3)
INTERFACE="enp0s3"

# Créer le fichier de configuration Netplan
sudo bash -c "cat > /etc/netplan/50-cloud-netcfg.yaml" <<EOF
network:
  version: 2
  ethernets:
    $INTERFACE:
      addresses:
        - 192.168.1.80/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 192.168.1.1
EOF

# Appliquer la configuration Netplan
sudo netplan apply

# Afficher la nouvelle configuration réseau
hostname -I
