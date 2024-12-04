#!/bin/bash
apt update -y && apt upgrade 
apt install apache2
systemctl start apache2
systemctl enable apache2
apt install mariadb-server
systemctl start mariadb
systemctl enable mariadb
add-apt-repository ppa:ondrej/php
apt update
apt install unzip apache2 libapache2-mod-php mariadb-server php php-gd php-json php-mbstring php-mysql php-xml php-zip php-curl php-bcmath php-intl php-imagick -y
sudo mysql  <<EOF
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'password';
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF
cd /var/www
sudo wget https://download.nextcloud.com/server/releases/nextcloud-30.0.2.zip
sudo unzip nextcloud-30.0.2.zip
sudo chown -R www-data:www-data nextcloud
sudo chmod -R 755 nextcloud
cp -r /var/www/nextcloud /var/www/html
sudo a2enmod rewrite headers env dir mime
sudo systemctl reload apache2
cd /var/www/html
sudo chown -R www-data:www-data nextcloud
sudo chmod -R 755 nextcloud

