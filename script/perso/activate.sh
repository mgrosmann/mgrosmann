#!/bin/bash
read -p "indiquer le repertoire" repertory
read -p "indiquer le nom du site" site
echo "Alias /$site  $repertory > /etc/apache2/conf-available/${site}.conf
a2enconf $folder
systemctl restart apache2
