#!/bin/bash
read -p "Entrer l'interface réseau: " interface
read -p "Entrer l'adresse IP (au format CIDR, ex: 192.168.1.10/24): " ip
read -p "Entrer la passerelle: " gateway
read -p "Entrer le DNS: " dns

cat <<EOF > /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  ethernets:
    $interface:
      addresses:
        - $ip
      routes:
        - to: default
          via: $gateway
      nameservers:
        addresses:
          - $dns
EOF
sudo netplan apply
hostname -I
