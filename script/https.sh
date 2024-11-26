#!/bin/bash
read -p "Entrez le nom du site : " site
read -p "Entrez le port : " port
openssl req -new -x509 -days 365 -nodes -out /etc/ssl/certs/${site}.crt -keyout /etc/ssl/private/${site}.key -subj "/CN=localhost"
chmod 440 /etc/ssl/private/${site}.key
sudo a2enmod ssl
cat <<EOF > /etc/apache2/sites-available/${site}-ssl.conf
<VirtualHost *:${port}>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/${site}
    ErrorLog \${APACHE_LOG_DIR}/${site}.error.log
    CustomLog \${APACHE_LOG_DIR}/${site}.access.log combined
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/${site}.crt
    SSLCertificateKeyFile /etc/ssl/private/${site}.key
    <FilesMatch "\.(?:cgi|shtml|phtml|php)$">
                SSLOptions +StdEnvVars
        </FilesMatch>
        <Directory /usr/lib/cgi-bin>
                SSLOptions +StdEnvVars
        </Directory>
</VirtualHost>
EOF
cd /etc/apache2/
echo "Listen ${port}" >> ports.conf