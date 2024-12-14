#!/bin/bash
apt update
apt install -y apache2 php php-{apcu,cli,common,curl,gd,imap,ldap,mysql,xmlrpc,xml,mbstring,bcmath,intl,zip,redis,bz2} libapache2-mod-php php-soap php-cas
mysql   <<EOF
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
CREATE DATABASE glpi;
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
GRANT SELECT ON \`mysql\`.\`time_zone_name\` TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
EOF
cd /var/www/html
wget https://github.com/glpi-project/glpi/releases/download/10.0.17/glpi-10.0.17.tgz
tar -xvzf glpi-10.0.17.tgz
chown root:root /var/www/html/glpi/ -R
chown www-data:www-data /var/www/html/glpi/ -R
systemctl restart apache2
