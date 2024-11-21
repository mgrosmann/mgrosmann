#!/bin/bash
apt-get update && sudo apt-get upgrade -y
 apt-get install -y apache2 mariadb-server php php-mysql php-xml php-mbstring php-curl php-gd php-intl php-ldap php-apcu
mysql_secure_installation <<EOF
n
n
n
n
y
y
EOF
mysql <<EOF
CREATE DATABASE glpi;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo -e "\e[31mVotre adresse IP est $IP_ADDRESS\e[0m"
wget https://github.com/glpi-project/glpi/releases/download/10.0.17/glpi-10.0.17.tgz
tar -xvzf glpi-10.0.17.tgz
mv glpi /var/www/html/
chown -R www-data:www-data /var/www/html/glpi
chmod -R 755 /var/www/html/glpi
a2ensite glpi.conf
systemctl restart apache2
