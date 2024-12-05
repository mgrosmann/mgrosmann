#!/bin/bash
read -p "Port MySQL: " port_sql
read -p "Port phpMyAdmin: " port_pma
read -p "Nom du projet: " name
cat <<EOF > docker-compose.yml
services:
  db:
    image: mysql
    container_name: db_$name
    environment:
      MYSQL_ROOT_PASSWORD: root
    ports:
      - "$port_sql:3306"

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin_$name
    environment:
      PMA_HOST: db
      MYSQL_ROOT_PASSWORD: root
    ports:
      - "$port_pma:80"
EOF

docker-compose up -d
