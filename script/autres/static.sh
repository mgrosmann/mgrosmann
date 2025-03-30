#!/bin/bash
read -p "Entrer l'interface réseau: " interface
read -p "Entrer l'adresse IP (au format CIDR, ex: 192.168.1.10/24): " ip
read -p "Entrer la passerelle: " gateway
read -p "Entrer le DNS: " dns
read -p "sur quel distri linux êtes vous ? (1 pour debian,2 pour ubntu) " linux
if [[ $linux == 1 ]]; then
  cat <<EOF > /etc/network/interfaces
  # This file describes the network interfaces available on your system
  # and how to activate them. For more information, see interfaces(5).

  source /etc/network/interfaces.d/*

  # The loopback network interface  
  auto lo
  iface lo inet loopback

  # The primary network interface
  allow-hotplug $interface
  iface $interface inet static
      address $ip
      gateway $gateway
      dns-nameservers $dns
  EOF
  systemctl restart networking.service
  hostname -I
if [[ $linux == 2 ]]; then
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
  netplan apply
  hostname -I
else
  echo "choix incorrect/distri linux non pris en compte"
fi
