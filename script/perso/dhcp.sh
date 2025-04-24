#!/bin/bash
read -p "Entrer l'interface réseau: " interface
read -p "sur quel distri linux êtes vous ? (1 pour debian,2 pour ubntu) " linux
if [[ $linux == 1 ]]; then
  echo "# This file describes the network interfaces available on your system
  # and how to activate them. For more information, see interfaces(5).

  source /etc/network/interfaces.d/*

  # The loopback network interface  
  auto lo
  iface lo inet loopback

  # The primary network interface
  allow-hotplug $interface
  iface $interface inet dhcp" > /etc/network/interfaces
  systemctl restart networking.service
  hostname -I
elif [[ $linux == 2 ]]; then
  echo "network:
    version: 2
    ethernets:
      $interface:
          dhcp4: true" > /etc/netplan/50-cloud-init.yaml
  apt install openvswitch-switch -y
  netplan apply
  hostname -I
else
  echo "choix incorrect/distri linux non pris en compte"
fi
