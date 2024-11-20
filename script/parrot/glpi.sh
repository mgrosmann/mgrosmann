#!/bin/bash

# Mettre à jour le système
sudo apt update && sudo apt upgrade -y

# Installer les dépendances nécessaires
sudo apt install -y apache2 mariadb-server php php-mysql php-xml php-mbstring php-curl php-gd php-intl php-ldap php-apcu

# Sécuriser l'installation de MariaDB
sudo mysql_secure_installation

# Configurer la base de données pour GLPI
sudo mysql -u root -p <<EOF
CREATE DATABASE glpi;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Télécharger et installer GLPI
wget https://github.com/glpi-project/glpi/releases/download/10.0.17/glpi-10.0.17.tgz
tar -xvzf glpi-10.0.17.tgz
sudo mv glpi /var/www/html/
sudo chown -R www-data:www-data /var/www/html/glpi
sudo chmod -R 755 /var/www/html/glpi

# Configurer Apache pour GLPI
sudo bash -c 'cat <<EOT > /etc/apache2/sites-available/glpi.conf
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html/glpi
    ServerName example.com
    <Directory /var/www/html/glpi>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/glpi_error.log
    CustomLog \${APACHE_LOG_DIR}/glpi_access.log combined
</VirtualHost>
EOT'

# Activer le site GLPI et redémarrer Apache
sudo a2ensite glpi.conf
sudo systemctl restart apache2

# Télécharger et installer l'agent GLPI
wget https://github.com/glpi-project/glpi-agent/releases/download/1.11/glpi-agent-1.11-linux-installer.pl
chmod +x glpi-agent-1.11-linux-installer.pl
sudo ./glpi-agent-1.11-linux-installer.pl

# Configurer l'agent GLPI
IP_ADDRESS=$(hostname -I | awk '{print $1}')
sudo bash -c "echo 'server = http://$IP_ADDRESS' > /etc/glpi-agent/glpi-agent.conf"

# Démarrer et activer l'agent GLPI
sudo systemctl start glpi-agent
sudo systemctl enable glpi-agent

echo "Installation et configuration de GLPI terminées avec succès."
