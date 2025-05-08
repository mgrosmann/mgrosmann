#!/bin/bash
if ! command -v mysql &> /dev/null; then
  wget mgrosmann.vercel.app/script/projet/mysql.sh
  bash mysql.sh
fi
if [ ! -f /var/www/html ]; then
  apt install apache2
fi
echo "quel est le mot de passe root du serveur sql ? "
read -s pass
apt update
apt install -y php php-{apcu,cli,common,curl,gd,imap,ldap,mysql,xmlrpc,xml,mbstring,bcmath,intl,zip,redis,bz2} libapache2-mod-php php-soap php-cas
echo "CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
CREATE DATABASE glpi;
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
GRANT SELECT ON \`mysql\`.\`time_zone_name\` TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
" > glpi.sql
mysql -uroot -p$mdp < glpi.sql
cd /var/www/html
wget https://github.com/glpi-project/glpi/releases/download/10.0.17/glpi-10.0.17.tgz
tar -xvzf glpi-10.0.17.tgz
chown root:root /var/www/html/glpi/ -R
chown www-data:www-data /var/www/html/glpi/ -R
