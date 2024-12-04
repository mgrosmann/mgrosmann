#!/bin/bash

# Adresse IP autorisée
ALLOWED_IP="192.168.1.78"

# Création des répertoires et fichiers pour iptables si nécessaire
mkdir -p /etc/iptables
touch /etc/iptables/rules.v4

# Réinitialisation des règles iptables
iptables -F
iptables -X

# Règles iptables pour SSH uniquement depuis l'adresse autorisée
iptables -A INPUT -p tcp --dport 22 -s $ALLOWED_IP -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP

# Autoriser les connexions établies et liées
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Autoriser le trafic local (loopback)
iptables -A INPUT -i lo -j ACCEPT

# Bloquer les pings (ICMP echo-request)
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Tout le reste est bloqué
iptables -A INPUT -j DROP

# Sauvegarde des règles iptables
iptables-save > /etc/iptables/rules.v4

# Configuration de SSH pour limiter les accès
echo "Configuration du service SSH..."
sed -i '/^#PermitRootLogin/s/^#//' /etc/ssh/sshd_config
sed -i '/^PermitRootLogin/s/yes/no/' /etc/ssh/sshd_config
sed -i '/^#PasswordAuthentication/s/^#//' /etc/ssh/sshd_config
sed -i '/^PasswordAuthentication/s/yes/no/' /etc/ssh/sshd_config

# Ajouter l'utilisateur et l'IP autorisée dans SSH
if ! grep -q "^AllowUsers .*@$ALLOWED_IP" /etc/ssh/sshd_config; then
    echo "AllowUsers utilisateur@$ALLOWED_IP" >> /etc/ssh/sshd_config
fi

# Redémarrage du service SSH pour appliquer les modifications
sudo systemctl restart ssh

# Confirmation de la configuration
echo "La configuration de la machine en DMZ a été effectuée avec succès."
echo "Connexion SSH autorisée uniquement depuis l'adresse : $ALLOWED_IP"
