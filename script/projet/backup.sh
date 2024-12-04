#!/bin/bash
SOURCE_DIR="/home/mgrosmann/desktop"
BACKUP_DIR="/home/mgrosmann/backup"
REMOTE_USER="mgrosmann"
REMOTE_HOST="192.168.1.45"
REMOTE_DIR="/home/mgrosmann/save"
rsync -avz $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR $BACKUP_DIR
# Message de confirmation
echo "La sauvegarde et la restauration avec rsync ont été effectuées avec succès."
