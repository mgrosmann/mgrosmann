#!/bin/bash
DB_USER="root"
DB_PASS="root"
DATE=$(date +"%Y%m%d%H%M")
SOURCE_DIR="/home/mgrosmann/desktop"
mkdir -p $SOURCE_DIR
mysqldump -u $DB_USER -p$DB_PASS --all-databases > $SOURCE_DIR/all-databases-$DATE.sql
echo "* * * * * root mysqldump -u $DB_USER -p$DB_PASS --all-databases > /root/save.mysql" >> /etc/crontab
