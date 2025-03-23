#!/bin/bash
a2dismod mpm_event
a2enmod mpm_prefork
a2enmod php8.2
systemctl restart apache2
echo "problème trouvé grace a la commande a2enmod php8.2"
