#!/bin/bash
pass=root
wget https://repo.zabbix.com/zabbix/7.2/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.2+debian12_all.deb
dpkg -i zabbix-release_latest_7.2+debian12_all.deb
apt update
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y
echo "create database IF NOT EXISTS zabbix character set utf8mb4 collate utf8mb4_bin;" > zbx.sql
echo "create user IF NOT EXISTS zabbix@localhost identified by 'zabbix';" >> zbx.sql
echo "grant all privileges on zabbix.* to zabbix@localhost;" >> zbx.sql
echo "set global log_bin_trust_function_creators = 1;" >> zbx.sql
echo "flush privileges;" >> zbx.sql
mysql -uroot -p$pass < zbx.sql
zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -pzabbix zabbix
echo "set global log_bin_trust_function_creators = 0;" > zbx.sql
mysql -uroot -p$pass < zbx.sql
echo "systemctl restart zabbix-server zabbix-agent apache2" > zbx.sh
echo "systemctl enable zabbix-server zabbix-agent apache2" >> zbx.sh
echo "nano /etc/zabbix/zabbix_server.conf pour DBPASSWORd, une fois fait, 'bash zbx.sh'"
