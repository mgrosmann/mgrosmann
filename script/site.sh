#!/bin/bash

# Demander le nom du site et le port
read -p "Entrez le nom du site : " site
read -p "Entrez le port : " port

# Naviguer vers le répertoire sites-available d'Apache
cd /etc/apache2/sites-available

# Copier la configuration par défaut vers une nouvelle configuration de site
cp 000-default.conf ${site}.conf

# Utiliser un document here pour mettre à jour la nouvelle configuration de site
cat <<EOF > ${site}.conf
<VirtualHost *:${port}>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/${site}
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Créer le répertoire racine du document pour le nouveau site
mkdir /var/www/${site}

# Ajouter du contenu HTML au répertoire racine du document du nouveau site
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

# Naviguer vers le répertoire de configuration d'Apache
cd /etc/apache2/

# Utiliser un document here pour mettre à jour la configuration des ports
cat <<EOF > ports.conf
Listen 80
Listen 8080
Listen 8000
Listen 9999
Listen ${port}
<IfModule ssl_module>
    Listen 443
</IfModule>
<IfModule mod_gnutls.c>
    Listen 443
</IfModule>
EOF

# Activer le nouveau site
sudo a2ensite ${site}

# Redémarrer Apache pour appliquer les modifications
systemctl restart apache2

# Recharger Apache pour s'assurer que toutes les configurations sont appliquées
systemctl reload apache2
