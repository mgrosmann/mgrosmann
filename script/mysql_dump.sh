#!/bin/bash
DB_USER="root"
DB_PASS="root"
DATE=$(date +"%Y%m%d%H%M")
SOURCE_DIR="/home/mgrosmann/desktop"
mkdir -p $SOURCE_DIR
mysqldump -u $DB_USER -p$DB_PASS --all-databases > $SOURCE_DIR/all-databases-$DATE.sql
echo "La sauvegarde de la base de données MySQL a été effectuée avec succès et copiée vers $SOURCE_DIR."
