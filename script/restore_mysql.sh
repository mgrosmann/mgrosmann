#!/bin/bash
DB_USER="root"
DB_PASS="root"
SOURCE_DIR="/home/mgrosmann/desktop
LATEST_BACKUP=$(ls -t "$SOURCE_DIR"/all-databases-*.sql 2>/dev/null | head -n 1)
if [ -z "$LATEST_BACKUP" ]; then
  echo "Aucune sauvegarde trouvée dans $SOURCE_DIR."
  exit 1
fi
mysql -u "$DB_USER" -p"$DB_PASS" < "$LATEST_BACKUP"
echo "La sauvegarde la plus récente ($LATEST_BACKUP) a été restaurée avec succès."
