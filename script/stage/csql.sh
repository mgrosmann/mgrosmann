#!/bin/bash
read -p "Voulez-vous créer un utilisateur ? (y/n) " user
if [[ "$user" == "y" || "$user" == "Y" ]]; then
  read -p "Nom d'utilisateur : " user
  read -sp "Mot de passe : " passwd
  echo ""
fi
read -p "Voulez-vous créer une base de données ? (y/n) " db
if [[ "$db" == "y" || "$db" == "Y" ]]; then
  read -p "Nom de la base de données : " db
fi
DB_USER="root"
DB_PASSWORD="root"
if [[ "$user" == "y" || "$user" == "Y" ]]; then
  mysql -u $DB_USER -p$DB_PASSWORD -e "CREATE USER '$user'@'localhost' IDENTIFIED BY '$passwd';"
fi
if [[ "$db" == "y" || "$db" == "Y" ]]; then
  mysql -u $DB_USER -p$DB_PASSWORD -e "CREATE DATABASE $db;"
  if [[ "$user" == "y" || "$user" == "Y" ]]; then
    mysql -u $DB_USER -p$DB_PASSWORD -e "GRANT ALL PRIVILEGES ON $db.* TO '$user'@'localhost';"
  fi
fi
mysql -u $DB_USER -p$DB_PASSWORD -e "FLUSH PRIVILEGES;"
echo "Privilèges appliqués."
echo "Opérations terminées."