#!/bin/bash
read -p "entrer l'interface réseau: " interface
read -p "entrer l'adresse ip: " ip
read -p "entrer la passerelle: " gateway
read -p "entrer le dns: " dns
cat <<EOF > /etc/netwplan/50-cloud-init.yaml
network:
  version: 2
  ethernets:
    $interface:
      addresses:
        - $ip
      gateway4: $gateway
      nameservers:
        addresses:
          - $dns
EOF
sudo netplan apply
hostname -I
