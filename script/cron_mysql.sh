#!/bin/bash
DB_USER="root"
DB_PASS="root"
mkdir -p "/root/backup_sql"
echo "* * * * * root mysqldump -u $DB_USER -p$DB_PASS --all-databases > /root/backup_sql/all-databases-\$(date +\%Y\%m\%d\%H\%M).sql" >> /etc/crontab
