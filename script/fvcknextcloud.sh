#!/bin/bash

# Message d'information
echo "Suppression complète de Nextcloud en cours..."

# Arrêter le service Apache
echo "Arrêt du serveur Apache..."
sudo systemctl stop apache2

# Supprimer les fichiers et dossiers de Nextcloud
echo "Suppression des fichiers Nextcloud dans /var/www/html..."
sudo rm -rf /var/www/html/*
sudo rm -r /var/www/*
mkdir /var/www/html
# Supprimer les fichiers de configuration Apache associés à Nextcloud
echo "Suppression des fichiers de configuration Apache..."
sudo rm -f /etc/apache2/sites-available/nextcloud.conf
sudo rm -f /etc/apache2/sites-enabled/nextcloud.conf

# Désactiver le site Nextcloud (si actif)
echo "Désactivation du site Apache Nextcloud..."
sudo a2dissite nextcloud
sudo systemctl reload apache2

# Supprimer les archives ZIP de Nextcloud si elles existent
echo "Suppression des archives téléchargées dans /var/www/html..."
sudo rm -f /var/www/html/latest.zip

# Supprimer la base de données Nextcloud
echo "Suppression de la base de données Nextcloud..."
sudo mysql  <<EOF
DROP DATABASE IF EXISTS nextcloud;
DROP USER IF EXISTS 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EOF

# Supprimer les modules PHP si nécessaire (optionnel, dépend de l'utilisation globale)
echo "Vous pouvez désinstaller les modules PHP si vous n'en avez plus besoin."
echo "Exemple : sudo apt remove php7.4-* libapache2-mod-php7.4 -y"

# Message de fin
echo "Désinstallation complète de Nextcloud terminée."

