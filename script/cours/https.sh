#!/bin/bash
read -p "Entrez le nom du site : " site
read -p "Entrez le port : " port
openssl req -new -x509 -days 365 -nodes -out /etc/ssl/certs/${site}.crt -keyout /etc/ssl/private/${site}.key -subj "/C=FR/ST=France/L=CF/O=SIO/OU=SIO/CN=${site}/emailAddress=root@${site}"
chmod 440 /etc/ssl/private/${site}.key
/sbin/a2enmod ssl
cat <<EOF > /etc/apache2/sites-available/${site}-ssl.conf
<VirtualHost *:${port}>
    ServerAdmin webmaster@localhost
    ServerName ${site}
    DocumentRoot /var/www/${site}

    ErrorLog \${APACHE_LOG_DIR}/${site}.error.log
    CustomLog \${APACHE_LOG_DIR}/${site}.access.log combined

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/${site}.crt
    SSLCertificateKeyFile /etc/ssl/private/${site}.key

    <Directory /var/www/${site}>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch "\.(?:cgi|shtml|phtml|php)$">
        SSLOptions +StdEnvVars
    </FilesMatch>
</VirtualHost>
EOF
echo "Listen ${port}" >> /etc/apache2/ports.conf
/sbin/a2ensite ${site}-ssl.conf
systemctl restart apache2
ip=$(hostname -I)
echo "Votre site HTTPS est maintenant prêt. Accédez à https://${ip}:${port}"
