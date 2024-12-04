#!/bin/bash
read -p "Entrez le nom du site : " site
read -p "Entrez le port : " port
cd /etc/apache2/sites-available
cat <<EOF > ${site}.conf
<VirtualHost *:${port}>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/${site}
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
mkdir /var/www/${site}
cat <<EOF > /var/www/${site}/index.html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bienvenue sur ${site}</title>
</head>
<body>
    <h1>Bienvenue sur ${site}</h1>
    <p>Ceci est une page de remplacement pour votre nouveau site.</p>
</body>
</html>
EOF
cd /etc/apache2/
echo "Listen ${port}" >> ports.conf
a2ensite ${site}
systemctl restart apache2
systemctl reload apache2
ip=$(hostname -I)
echo "votre site est maintenant pres veuillez vous rendre sur $ip:${port}"
