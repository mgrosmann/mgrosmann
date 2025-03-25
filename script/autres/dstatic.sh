#!/bin/bash
read -p "entrer l'interface réseau: " interface
read -p "entrer l'adresse ip: " ip
read -p "entrer la passerelle: " gateway
read -p "entrer le dns: " dns
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
