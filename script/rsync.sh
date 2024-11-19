#!/bin/bash

echo "Installation de rsync..."
sudo apt update
sudo apt install -y rsync

# Créer les répertoires nécessaires
mkdir -p /home/mgrosmann/backup
mkdir -p /home/mgrosmann/desktop
mkdir -p /home/mgrosmann/save

# Variables de configuration
SOURCE_DIR="/home/mgrosmann/desktop"
BACKUP_DIR="/home/mgrosmann/backup"
REMOTE_USER="mgrosmann"
REMOTE_HOST="192.168.1.45"
REMOTE_DIR="/home/mgrosmann/save"

# Créer un fichier de test
echo "test de la configuration de rsync" > $SOURCE_DIR/test.txt


# Sauvegarder le répertoire local vers le serveur distant
rsync -avz $SOURCE_DIR $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR

# Supprimer le fichier de test local
rm $SOURCE_DIR/test.txt

# Restaurer le répertoire depuis le serveur distant vers le répertoire de restauration local
rsync -avz $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR $BACKUP_DIR

# Message de confirmation
echo "La sauvegarde et la restauration avec rsync ont été effectuées avec succès."
