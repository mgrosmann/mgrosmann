#!/bin/bash

# Script pour mettre à jour PHP vers 8.1 et installer toutes les extensions nécessaires pour Nextcloud

# Fonction pour vérifier et ajouter le dépôt PHP Ondrej (si nécessaire)
add_php_repository() {
    echo "Ajout du dépôt PHP Ondrej pour les versions récentes de PHP..."
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update
}

# Fonction pour installer PHP 8.1 et les extensions nécessaires
install_php_8_1() {
    echo "Installation de PHP 8.1 et des extensions nécessaires pour Nextcloud..."

    # Installer PHP 8.1 et les extensions nécessaires pour Nextcloud
    sudo apt install -y \
        php8.1 php8.1-cli php8.1-fpm php8.1-mysql php8.1-xml php8.1-mbstring \
        php8.1-curl php8.1-zip php8.1-bcmath php8.1-json php8.1-intl php8.1-opcache \
        php8.1-imagick php8.1-gd php8.1-sqlite3 php8.1-memcached php8.1-redis php8.1-soap \
        libapache2-mod-php8.1 \
        php8.1-dom php8.1-xmlwriter php8.1-xmlreader php8.1-libxml php8.1-simplexml

    echo "PHP 8.1 et toutes les extensions nécessaires pour Nextcloud ont été installés."
}

# Fonction pour configurer PHP-FPM (si utilisé avec Nginx)
configure_php_fpm() {
    echo "Configuration de PHP-FPM pour utiliser PHP 8.1..."

    # Si vous utilisez Nginx, modifiez le fichier de configuration de PHP-FPM
    # Assurez-vous que PHP 8.1 est utilisé avec Nginx en vérifiant la configuration

    # (Un exemple pour Nginx)
    # sudo sed -i 's|fastcgi_pass unix:/run/php/php7.4-fpm.sock|fastcgi_pass unix:/run/php/php8.1-fpm.sock|g' /etc/nginx/sites-available/default
    # sudo systemctl restart nginx
    # sudo systemctl restart php8.1-fpm
    echo "PHP-FPM configuré pour PHP 8.1 (modification de la configuration Nginx si nécessaire)."
}

# Fonction pour activer PHP 8.1 avec Apache (si Apache est utilisé)
configure_apache() {
    echo "Activation de PHP 8.1 avec Apache..."

    # Installer et activer le module PHP 8.1 avec Apache
    sudo apt install -y libapache2-mod-php8.1
    sudo a2dismod php7.4
    sudo a2enmod php8.1
    sudo systemctl restart apache2

    echo "PHP 8.1 activé avec Apache."
}

# Fonction pour vérifier la version de PHP installée
check_php_version() {
    php -v
}

# Fonction pour redémarrer le serveur web (Apache ou Nginx)
restart_web_server() {
    echo "Redémarrage du serveur web..."

    # Si Apache est utilisé
    sudo systemctl restart apache2

    # Si Nginx est utilisé
    # sudo systemctl restart nginx

    echo "Serveur web redémarré."
}

# Fonction pour désinstaller PHP 7.4 (facultatif)
remove_php_7_4() {
    echo "Suppression de PHP 7.4 et de ses extensions..."

    sudo apt remove --purge -y \
        php7.4 php7.4-cli php7.4-fpm php7.4-mysql php7.4-xml php7.4-mbstring \
        php7.4-curl php7.4-zip php7.4-bcmath php7.4-json php7.4-intl php7.4-opcache

    sudo apt autoremove -y

    echo "PHP 7.4 et ses extensions ont été supprimés."
}

# Vérification de la version actuelle de PHP
echo "Vérification de la version actuelle de PHP..."
check_php_version

# Ajouter le dépôt PHP Ondrej si nécessaire
add_php_repository

# Installer PHP 8.1 et les extensions nécessaires pour Nextcloud
install_php_8_1

# Configurer PHP-FPM (si utilisé)
configure_php_fpm

# Configurer Apache pour PHP 8.1 (si Apache est utilisé)
configure_apache

# Vérification de la version PHP après l'installation
echo "Vérification de la version de PHP après la mise à jour..."
check_php_version

# Redémarrer le serveur web pour appliquer les changements
restart_web_server

# Supprimer PHP 7.4 (facultatif, décommentez si vous souhaitez le faire)
# remove_php_7_4

echo "Mise à jour vers PHP 8.1 terminée avec succès !"

