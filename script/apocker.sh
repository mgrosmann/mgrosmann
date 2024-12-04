#!/bin/bash
read -p "Voulez-vous créer un nouveau site (1) ou associer un dossier existant (2) ? " choice
if [ "$choice" -eq 1 ]; then
  read -p "Entrez le nom du nouveau site : " site_name
  read -p "Entrez le port pour le nouveau site : " site_port
  cat <<EOF >> compose_$site_name.yaml
services:
  $site_name:
    container_name: $site_name
    image: httpd
    ports:
      - "$site_port:80"
    networks:
      - "apache_network"
networks:
  apache_network:
EOF
  mkdir -p "docker_webfile/$site_name"
  echo "bienvenue sur $site_name situe sur le port $site_port" > "docker_webfile/$site_name/index.html"
  docker compose -f "compose_$site_name.yaml" up -d
  FILE_PATH="/usr/local/apache2/htdocs"
  docker exec "$site_name" rm -rf "$FILE_PATH"
  docker cp "docker_webfile/$site_name" "$site_name:/usr/local/apache2/htdocs"
elif [ "$choice" -eq 2 ]; then
  read -p "Entrez le nom du dossier existant dans /var/www : " folder_name
  read -p "Entrez le port sur lequel appliquer le code HTML importé : " site_port
  read -p "Entrez le nom du site sur lequel appliquer le code HTML importé : " site_name
  if [ -d "/var/www/$folder_name" ]; then
    FILE_PATH="/usr/local/apache2/htdocs"
    docker exec "$site_name" rm -rf "$FILE_PATH"
    docker cp "/var/www/$folder_name" "$site_name:/usr/local/apache2/htdocs"
    echo "Dossier /var/www/$folder_name associé avec succès au site $site_name."
  else
    echo "Le dossier /var/www/$folder_name n'existe pas."
  fi
fi