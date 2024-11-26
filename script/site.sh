#!/bin/bash

# Navigate to the Apache sites-available directory
cd /etc/apache2/sites-available

# Copy the default configuration to a new site configuration
cp 000-default.conf nouveausite.conf

# Use a here document to update the new site configuration
cat <<EOF > nouveausite.conf
<VirtualHost *:9000>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/nouveausite
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Create the document root directory for the new site
mkdir /var/www/nouveausite

# Navigate to the Apache configuration directory
cd /etc/apache2/

# Use a here document to update the ports configuration
cat <<EOF > ports.conf
Listen 80
Listen 8080
Listen 8000
Listen 9000
<IfModule ssl_module>
    Listen 443
</IfModule>
<IfModule mod_gnutls.c>
    Listen 443
</IfModule>
EOF

# Enable the new site
sudo a2ensite nouveausite

# Restart Apache to apply the changes
systemctl restart apache2

# Reload Apache to ensure all configurations are applied
systemctl reload apache2
