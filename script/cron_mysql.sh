#!/bin/bash
DB_USER="root"
DB_PASS="root"
SOURCE_DIR="/home/mgrosmann/desktop"
mkdir -p "$SOURCE_DIR"
echo "* * * * * root mysqldump -u $DB_USER -p$DB_PASS --all-databases > /root/all-databases-\$(date +\%Y\%m\%d\%H\%M).sql" >> /etc/crontab
