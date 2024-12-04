#!/bin/bash
cat <<EOL > compose.yaml
services:
  
  db:
    container_name: db
    image: mysql
    ports:
      - "33306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: P@ssw0rd
      MYSQL_DATABASE: mysql_db
      MYSQL_USER: mgrosmann
      MYSQL_PASSWORD: P@ssw0rd
    networks:
      - "db_network"

  phpmyadmin:
    container_name: phpmyadmin
    image: phpmyadmin
    ports:
      - "9999:80"
    environment:
      HOST: mysql_db
      USERNAME: mgrosmann
      PASSWORD: P@ssw0rd
    depends_on:
      - "db"
    networks:
      - "db_network"
  apache:
    container_name: apache
    image: httpd
    ports:
      - "8000:80"
    networks:
      - "db_network"
  ftp:
    container_name: ftp
    image: fauria/vsftpd
    ports:
      - "21:21"
      - "21100-21110:21100-21110"
    environment:
      FTP_USER: user
      FTP_PASS: pass
    networks:
      - "db_network"
networks:
  db_network:    
EOL
docker compose up -d

