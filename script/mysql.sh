#!/bin/bash
apt update && apt install mariadb-server mysql-server -y
mysql  <<EOF
DROP USER 'root'@'localhost';
CREATE USER 'root'@'localhost' IDENTIFIED BY 'root';
CREATE DATABASE test;
GRANT ALL PRIVILEGES ON test.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF
