#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y apache2 mariadb-server php php-mysql php-xml php-mbstring php-curl php-gd php-intl php-ldap php-apcu

# Automatiser mysql_secure_installation
sudo mysql_secure_installation <<EOF

n
n
n
n
y
y
EOF

sudo mysql <<EOF
CREATE DATABASE glpi;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

wget https://github.com/glpi-project/glpi/releases/download/10.0.17/glpi-10.0.17.tgz
tar -xvzf glpi-10.0.17.tgz
sudo mv glpi /var/www/html/
sudo chown -R www-data:www-data /var/www/html/glpi
sudo chmod -R 755 /var/www/html/glpi
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo "Votre adresse IP est $IP_ADDRESS"
sudo bash -c 'cat <<EOT > /etc/apache2/sites-available/glpi.conf
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html/glpi
    ServerName '$IP_ADDRESS'
    <Directory /var/www/html/glpi>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/glpi_error.log
    CustomLog \${APACHE_LOG_DIR}/glpi_access.log combined
</VirtualHost>
EOT'
sudo a2ensite glpi.conf
sudo systemctl restart apache2
