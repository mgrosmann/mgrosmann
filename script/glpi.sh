#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y apache2 mariadb-server php php-mysql php-xml php-mbstring php-curl php-gd php-intl php-ldap php-apcu
sudo mysql_secure_installation
sudo mysql -u root -p <<EOF
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
sudo a2ensite glpi.conf
sudo systemctl restart apache2
#___________________________________________________________________

wget https://github.com/glpi-project/glpi-agent/releases/download/1.11/glpi-agent-1.11-linux-installer.pl
chmod +x glpi-agent-1.11-linux-installer.pl
sudo ./glpi-agent-1.11-linux-installer.pl
sudo bash -c 'echo "server = http://192.168.1.XXX/glpi/front/inventory.php" > /etc/glpi-agent/glpi-agent.conf'
sudo systemctl start glpi-agent
sudo systemctl enable glpi-agent
