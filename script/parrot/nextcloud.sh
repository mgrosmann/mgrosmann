#!/bin/bash

# Mettre à jour le système
sudo apt-get update -y && sudo apt-get upgrade -y

# Installer Apache2
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2

# Installer MariaDB
sudo apt-get install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Ajouter le dépôt PHP
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update

# Installer PHP et les extensions nécessaires
sudo apt-get install -y unzip apache2 libapache2-mod-php mariadb-server php php-gd php-json php-mbstring php-mysql php-xml php-zip php-curl php-bcmath php-intl php-imagick

# Configurer MariaDB pour Nextcloud
sudo mysql <<EOF
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'password';
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Télécharger et installer Nextcloud
cd /var/www
sudo wget https://download.nextcloud.com/server/releases/nextcloud-30.0.2.zip
sudo unzip nextcloud-30.0.2.zip
sudo chown -R www-data:www-data nextcloud
sudo chmod -R 755 nextcloud
sudo cp -r /var/www/nextcloud /var/www/html

# Configurer Apache pour Nextcloud
sudo a2enmod rewrite headers env dir mime
sudo systemctl reload apache2

# Ajuster les permissions pour Nextcloud
cd /var/www/html
sudo chown -R www-data:www-data nextcloud
sudo chmod -R 755 nextcloud

echo "Installation et configuration de Nextcloud terminées avec succès."
