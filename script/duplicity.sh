#!/bin/bash

# Mettre à jour et installer Duplicity
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y duplicity

# Créer le répertoire de sauvegarde
mkdir -p /home/mgrosmann/backup

# Définir les variables de source et de destination
SOURCE_DIR="/home/mgrosmann/desktop"
DEST_DIR="/home/mgrosmann/backup"
REMOTE_DIR="scp://mgrosmann@sio.jbdelasalle.com:1622//home/SIO/mgrosmann/backup"
PASSPHRASE="password"

# Exporter la passphrase pour Duplicity
export PASSPHRASE=$PASSPHRASE

# Effectuer la sauvegarde avec les options SSH pour spécifier le port
duplicity --ssh-options="-oPort=1622" $SOURCE_DIR $REMOTE_DIR

# Restaurer la sauvegarde avec les options SSH pour spécifier le port
duplicity --ssh-options="-oPort=1622" restore $REMOTE_DIR $DEST_DIR

# Supprimer les sauvegardes plus anciennes que 30 jours avec les options SSH pour spécifier le port
duplicity --ssh-options="-oPort=1622" remove-older-than 30D --force $REMOTE_DIR

# Désactiver la passphrase
unset PASSPHRASE

# Message de confirmation
echo "Duplicity a été installé et configuré avec succès."

