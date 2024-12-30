#!/bin/bash
SOURCE_DIR="/home/mgrosmann/desktop"
BACKUP_DIR="/home/mgrosmann/backup"
REMOTE_USER="mgrosmann"
REMOTE_HOST="192.168.1.45"
REMOTE_DIR="/home/mgrosmann/save"
FILE_NAME="test.txt"
FILE_PATH="$SOURCE_DIR/$FILE_NAME"
echo "Ceci est un test de sauvegarde avec rsync." > $FILE_PATH
rsync -avz $FILE_PATH $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
rm $FILE_PATH
rsync -avz $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/$FILE_NAME $BACKUP_DIR
echo "La sauvegarde et la restauration avec rsync ont été effectuées avec succès."
