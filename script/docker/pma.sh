#!/bin/bash
  read -p "Entrez le nom du conteneur MySQL : " mysql_name
  read -p "Entrez le port MySQL : " mysql_port
  read -p "Entrez le mot de passe root pour MySQL : " mysql_root_password
  read -p "Entrez le nom de la base de données à créer : " mysql_database
  read -p "Entrez le nom de l'utilisateur MySQL : " mysql_user
  read -p "Entrez le mot de passe pour cet utilisateur : " mysql_user_password
  read -p "Entrez le nom du conteneur phpMyAdmin : " phpmyadmin_name
  read -p "Entrez le port pour phpMyAdmin : " phpmyadmin_port
  cat <<EOF >> docker-compose-$mysql_name.yaml
services:
 $mysql_name:
    container_name: $mysql_name
    image: mysql
    ports:
      - "$mysql_port:3306"
    environment:
      MYSQL_ROOT_PASSWORD: $mysql_root_password
      MYSQL_DATABASE: $mysql_database
      MYSQL_USER: $mysql_user
      MYSQL_PASSWORD: $mysql_user_password
    networks:
      - "$mysql_name-network"

  $phpmyadmin_name:
    container_name: $phpmyadmin_name
    image: phpmyadmin
    ports:
      - "$phpmyadmin_port:80"
    environment:
      HOST: $mysql_database
      USERNAME: $mysql_user
      PASSWORD: $mysql_user_password
    depends_on:
      - "$mysql_name"
    networks:
      - "$mysql_name-network"

networks:
  $mysql_name-network:
EOF
  docker compose -f docker-compose-$mysql_name.yaml up -d