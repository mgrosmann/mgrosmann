#!/bin/bash
DB_USER="root"
DB_PASS="root"
BACKUP_DIR="/home/mgrosmann/backup"
DATE=$(date +"%Y%m%d%H%M")
SOURCE_DIR="/home/mgrosmann/desktop"
REMOTE_USER="mgrosmann"
REMOTE_HOST="192.168.1.45"
REMOTE_DIR="/home/mgrosmann/save"
mkdir -p $BACKUP_DIR
mysqldump -u $DB_USER -p$DB_PASS --all-databases > $BACKUP_DIR/all-databases-$DATE.sql
find $BACKUP_DIR -type f -name "*.sql" -mtime +7 -exec rm {} \;
rsync -avz $BACKUP_DIR/ $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
rsync -avz $SOURCE_DIR/ $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
echo "La sauvegarde et la restauration avec rsync ont été effectuées avec succès."
