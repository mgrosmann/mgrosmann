#!/bin/bash
DB_USER="root"
DB_PASS="root"
DATE=$(date +"%Y%m%d%H%M")
SOURCE_DIR="/home/mgrosmann/desktop"
mkdir -p $SOURCE_DIR
# Sauvegarder toutes les bases de données, y compris les utilisateurs et les privilèges
mysqldump -u $DB_USER -p$DB_PASS --all-databases > $SOURCE_DIR/all-databases-$DATE.sql
# Message de confirmation
echo "La sauvegarde de la base de données MySQL a été effectuée avec succès et copiée vers $SOURCE_DIR."
