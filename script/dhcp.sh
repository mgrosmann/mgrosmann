#!/bin/bash
#apt install -y isc-dhcp-client
# Variables
INTERFACE="eth0"  # Changez cela selon le nom de votre interface réseau
LOG_FILE="/var/log/dhcp_renewal.log"
# Fonction pour forcer le renouvellement de l'adresse IP via DHCP
renew_ip() {
    echo "$(date) - Tentative de libération de l'adresse IP actuelle" >> $LOG_FILE
    sudo dhclient -r $INTERFACE  # Libérer l'adresse IP actuelle
    if [ $? -eq 0 ]; then
        echo "$(date) - Adresse IP libérée avec succès" >> $LOG_FILE
    else
        echo "$(date) - Erreur lors de la libération de l'adresse IP" >> $LOG_FILE
        exit 1
    fi
    echo "$(date) - Demande d'une nouvelle adresse IP via DHCP" >> $LOG_FILE
    sudo dhclient $INTERFACE  # Demander une nouvelle adresse IP
    if [ $? -eq 0 ]; then
        echo "$(date) - Nouvelle adresse IP obtenue avec succès" >> $LOG_FILE
    else
        echo "$(date) - Erreur lors de la demande de la nouvelle adresse IP" >> $LOG_FILE
        exit 1
    fi
}
# Exécuter la fonction de renouvellement
renew_ip
echo "Nouvelle adresse IP obtenue avec succès, l'adresse est "
hostname -I
