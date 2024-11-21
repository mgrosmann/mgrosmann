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
bash -c 'cat <<EOT > /etc/apache2/sites-available/glpi.conf
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html/glpi
    ServerName 192.168.1.78
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
#___________________________________________________________________
