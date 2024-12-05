#!/bin/bash
read -p "port myql" port_sql
read -p "port pma" port_pma
read -p "nom projet pma" name
cat <<EOF > $name.yaml
services:

  db_$name:
    container_name: db_$name
    image: mysql
    ports:
      - "$port_sql:3306"
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mysql_db_$name
      MYSQL_USER: mgrosmann
      MYSQL_PASSWORD: password
    networks:
      - "network_$name"

  phpmyadmin_$name:
    container_name: phpmyadmin_$name
    image: phpmyadmin
    ports:
      - "$port_pma:80"
    environment:
      HOST: mysql_db_$name
      USERNAME: mgrosmann
      PASSWORD: password
    depends_on:
      - "db_$name"
    networks:
      - "network_$name"
networks:
  network_$name:
EOF
docker compose -f "$name.yaml" up -d