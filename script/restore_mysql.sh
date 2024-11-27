#!/bin/bash
DB_USER="root"
DB_PASS="root"
SOURCE_DIR="/home/mgrosmann/desktop"
LATEST_BACKUP=$(ls -t $SOURCE_DIR/all-databases-*.sql | head -n 1)
mysql -u $DB_USER -p$DB_PASS < "$LATEST_BACKUP"
echo "La sauvegarde la plus récente ($LATEST_BACKUP) a été restaurée avec succès."
