#!/bin/bash
USER="root"
PASS="root"
apt update
apt install mariadb-server -y
mysql_secure_installation <<EOF
y
n
y
y
y
y
EOF
mysql -u root -e "CREATE USER 'piwigo'@'localhost' IDENTIFIED BY 'piwigo';"
mysql -u root -e "CREATE DATABASE piwigo;"
mysql -u root -e "grant all privileges on piwigo.* to 'piwigo'@'localhost';"
mysql -u root -e "CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';"
mysql -u root -e "CREATE DATABASE glpi;"
mysql -u root -e "grant all privileges on glpi.* to 'glpi'@'localhost'"
mysql -u root -e "CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'nextcloud';"
mysql -u root -e "CREATE DATABASE nextcloud;"
mysql -u root -e "grant all privileges on nextcloud.* to 'nextcloud'@'localhost'"
mysql -u root -e "CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY 'pma';"
mysql -u root -e "CREATE DATABASE phpmyadmin;"
mysql -u root -e "grant all privileges on phpmyadmin.* to 'phpmyadmin'@'localhost'"
mysql -u root -e "FLUSH PRIVILEGES;"
echo "Privilèges appliqués."
echo "Opérations terminées."
mysql  <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
CREATE DATABASE test;
GRANT ALL PRIVILEGES ON test.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
EOF