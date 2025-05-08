#!/bin/bash
if ! command -v mysql &> /dev/null; then
  wget mgrosmann.vercel.app/script/projet/mysql.sh
  bash mysql.sh
fi
echo "quel est le mot de passe root du serveur sql ? "
read -s pass
apt update -y && apt upgrade 
if [ ! -f /var/www/html ]; then
  apt install apache2
fi
add-apt-repository ppa:ondrej/php
apt update
apt install unzip libapache2-mod-php  php php-gd php-json php-mbstring php-mysql php-xml php-zip php-curl php-bcmath php-intl php-imagick -y
echo"CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'password';
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;" > nextcloud.sql
mysql -uroot -p$pass < nextcloud.sql
wget https://download.nextcloud.com/server/releases/nextcloud-30.0.2.zip
unzip nextcloud-30.0.2.zip 
chown -R www-data:www-data nextcloud
chmod -R 755 nextcloud
cp -r nextcloud /var/www/html
a2enmod rewrite headers env dir mime
systemctl reload apache2
