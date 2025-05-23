#!/bin/bash
if ! command -v mysql &> /dev/null; then
  wget mgrosmann.vercel.app/script/projet/mysql.sh
  bash mysql.sh
fi
echo "quel est le mot de passe root du serveur sql ? "
read -s pass
read -p "quel est votre distrib linux ? (1 pour debian 2 pour ubuntu) " linux
if [[ $linux == 1 ]]; then
  wget https://repo.zabbix.com/zabbix/7.2/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.2+debian12_all.deb
  dpkg -i zabbix-release_latest_7.2+debian12_all.deb
elif [[ $linux == 2 ]]; then
  wget https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu24.04_all.deb
  dpkg -i zabbix-release_latest_7.2+ubuntu24.04_all.deb
else
  echo "choix incorrect, veuilez réessayer"
fi
apt update
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y
echo "create database IF NOT EXISTS zabbix character set utf8mb4 collate utf8mb4_bin;
create user IF NOT EXISTS zabbix@localhost identified by 'zabbix';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
flush privileges;" > zbx.sql
mysql -uroot -p$pass < zbx.sql
zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz > zbx.sql
echo "set global log_bin_trust_function_creators = 0;" >> zbx.sql
mysql -uroot -p$pass zabbix < zbx.sql
rm zbx.sql
echo "systemctl restart zabbix-server zabbix-agent apache2" > zbx.sh
echo "systemctl enable zabbix-server zabbix-agent apache2" >> zbx.sh
echo "nano /etc/zabbix/zabbix_server.conf pour DBPASSWORd, une fois fait, 'bash zbx.sh'"
