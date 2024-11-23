#!/bin/bash
apt update && apt upgrade -y
apt install -y mysql-client rclone cron
rclone config create myonedrive onedrive
DB_USER="root"
DB_PASS="root"
DB_NAME="test" 
BACKUP_DIR="/backup/mysql"
REMOTE_DIR="myonedrive:Save_Mysql"
DATE=$(date +%F)
mkdir -p $BACKUP_DIR"
cat <<EOF > /usr/local/bin/mysql_backup.sh
#!/bin/bash
DB_USER="$DB_USER"
DB_PASS="$DB_PASS"
DB_NAME="$DB_NAME"
BACKUP_DIR="$BACKUP_DIR"
REMOTE_DIR="$REMOTE_DIR"
DATE=\$(date +%F)
BACKUP_FILE="\$BACKUP_DIR/\${DB_NAME}_\${DATE}.sql"
mysqldump -u\$DB_USER -p\$DB_PASS \$DB_NAME > \$BACKUP_FILE
if [ \$? -ne 0 ]; then
    echo "Erreur lors de la sauvegarde MySQL."
    exit 1
fi
echo "Envoi de la sauvegarde sur OneDrive..."
rclone copy \$BACKUP_FILE \$REMOTE_DIR
if [ \$? -eq 0 ]; then
    echo "Sauvegarde envoyée avec succès sur OneDrive."
else
    echo "Erreur lors de l'envoi de la sauvegarde sur OneDrive."
    exit 1
fi
find \$BACKUP_DIR -type f -mtime +7 -exec rm {} \;
echo "Sauvegarde terminée."
EOF
chmod +x /usr/local/bin/mysql_backup.sh
echo "Ajout de la tâche cron..."
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/mysql_backup.sh") | crontab -
