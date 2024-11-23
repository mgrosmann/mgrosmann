#!/bin/bash
mkdir -p /home/backup_MySql
DB_USER="root"
DB_PASS="root"
BACKUP_DIR="/home/backup_MySql"
DATE=$(date +"%Y%m%d%H%M")
mysqldump -u $DB_USER -p$DB_PASS --all-databases > $BACKUP_DIR/all-databases-$DATE.sql
find $BACKUP_DIR -type f -name "*.sql" -mtime +7 -exec rm {} \;
(crontab -l ; echo "0 2 * * * /chemin/vers/le/script_de_sauvegarde.sh") | crontab -
