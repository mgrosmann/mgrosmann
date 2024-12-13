#!/bin/bash
apt-get update && apt-get upgrade -y
apt-get install -y apache2  php php-mysql php-xml php-mbstring php-curl php-gd php-intl php-ldap php-apcu
mysql <<EOF
CREATE DATABASE glpi;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF
wget https://github.com/glpi-project/glpi/releases/download/10.0.17/glpi-10.0.17.tgz
tar -xvzf glpi-10.0.17.tgz
mv glpi /var/www/html/
chown -R www-data:www-data /var/www/html/glpi
chmod -R 755 /var/www/html/glpi
systemctl restart apache2
