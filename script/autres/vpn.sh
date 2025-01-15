#!/bin/bash

# Mettre à jour le système et installer les dépendances nécessaires
sudo apt update && sudo apt upgrade -y
sudo apt install -y openvpn easy-rsa

# Créer le répertoire pour Easy-RSA et initialiser l'infrastructure PKI
make-cadir ~/openvpn-ca
cd ~/openvpn-ca || { echo "Erreur : impossible d'accéder au répertoire ~/openvpn-ca"; exit 1; }
./easyrsa init-pki

# Construire l'autorité de certification (CA)
echo -e "\n\n" | ./easyrsa build-ca nopass

# Générer une clé et une demande de certificat pour le serveur
./easyrsa gen-req server nopass
cp pki/private/server.key /etc/openvpn/

# Signer le certificat du serveur avec la CA
echo "yes" | ./easyrsa sign-req server server
cp pki/issued/server.crt /etc/openvpn/
cp pki/ca.crt /etc/openvpn/

# Générer des paramètres Diffie-Hellman
./easyrsa gen-dh
cp pki/dh.pem /etc/openvpn/

# Générer une clé de sécurité TLS pour renforcer la sécurité
openvpn --genkey --secret ta.key
sudo cp ta.key /etc/openvpn/

# Configurer le fichier serveur OpenVPN
sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/server.conf

# Modifier automatiquement la configuration
sudo sed -i 's/^;port 1194/port 1194/' /etc/openvpn/server.conf
sudo sed -i 's/^;proto udp/proto udp/' /etc/openvpn/server.conf
sudo sed -i 's/^;dev tun/dev tun/' /etc/openvpn/server.conf
sudo sed -i 's|ca ca.crt|ca /etc/openvpn/ca.crt|' /etc/openvpn/server.conf
sudo sed -i 's|cert server.crt|cert /etc/openvpn/server.crt|' /etc/openvpn/server.conf
sudo sed -i 's|key server.key|key /etc/openvpn/server.key|' /etc/openvpn/server.conf
sudo sed -i 's|dh dh2048.pem|dh /etc/openvpn/dh.pem|' /etc/openvpn/server.conf
sudo sed -i 's/^;tls-auth ta.key 0/tls-auth /etc/openvpn/ta.key 0/' /etc/openvpn/server.conf
sudo sed -i 's/^;cipher AES-256-CBC/cipher AES-256-CBC/' /etc/openvpn/server.conf
sudo sed -i '/^;push "route 192.168.10.0 255.255.255.0"/a push "route 192.168.0.0 255.255.255.0"' /etc/openvpn/server.conf
sudo sed -i 's/^;user nobody/user nobody/' /etc/openvpn/server.conf
sudo sed -i 's/^;group nogroup/group nogroup/' /etc/openvpn/server.conf

# Activer et démarrer le service OpenVPN
sudo systemctl start openvpn@server
sudo systemctl enable openvpn@server

# Vérification de l'état du service
if systemctl is-active --quiet openvpn@server; then
    echo "OpenVPN a été configuré et démarré avec succès."
else
    echo "Erreur : le service OpenVPN ne s'est pas démarré correctement. Vérifiez les logs avec 'sudo journalctl -u openvpn@server'."
    exit 1
fi
