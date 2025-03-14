#!/bin/bash
pass=root
wget https://repo.zabbix.com/zabbix/7.2/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.2+debian12_al>dpkg -i zabbix-release_latest_7.2+debian12_all.deb
apt update
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y
apt install mariadb-server -y
echo "create database IF NOT EXISTS zabbix character set utf8mb4 collate utf8mb4_bin;" > zbx.sql
echo "create user IF NOT EXISTS zabbix@localhost identified by 'zabbix';" >> zbx.sql
echo "grant all privileges on zabbix.* to zabbix@localhost;" >> zbx.sql
echo "set global log_bin_trust_function_creators = 1;" >> zbx.sql
echo "flush privileges;" >> zbx.sql
mysql -uroot -p$pass < zbx.sql
zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
echo "set global log_bin_trust_function_creators = 0;" | mysql -uroot -p$pass
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
echo "Editer /etc/zabbix/zabbix_server.conf avec DBPassword"
