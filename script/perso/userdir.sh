#!/bin/bash
read -p "quel nom pour votre user: " user
mkdir -p /home/html/
useradd $user -m -d /home/html/$user
mkdir /home/html/$user/perso_html
chown -R $user /home/html/$user
echo "coucou bienvenue sur le site de moi, $user" > /home/html/$user/perso_html/index.html
echo "le 'votre site est disponible sur http://localhost/~$user"
