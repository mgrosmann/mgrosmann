#!/bin/bash

# Variables de configuration
SOURCE_DIR="/home/mgrosmann/desktop"
BACKUP_DIR="/home/mgrosmann/backup"
REMOTE_USER="mgrosmann"
REMOTE_HOST="192.168.1.45"
REMOTE_DIR="/home/mgrosmann/save"
FILE_NAME="test.txt"
FILE_PATH="$SOURCE_DIR/$FILE_NAME"

# Créer un fichier de test et le remplir de caractères
echo "Ceci est un test de sauvegarde avec rsync." > $FILE_PATH

# Sauvegarder le fichier vers le serveur distant
rsync -avz $FILE_PATH $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR

# Supprimer le fichier du répertoire source
rm $FILE_PATH

# Restaurer le fichier depuis le serveur distant vers le répertoire de sauvegarde
rsync -avz $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/$FILE_NAME $BACKUP_DIR

# Message de confirmation
echo "La sauvegarde et la restauration avec rsync ont été effectuées avec succès."

