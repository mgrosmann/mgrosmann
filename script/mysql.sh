#!/bin/bash
apt update
apt install mariadb-server -y
mysql_secure_installation <<EOF
y
n
y
y
y
y
EOF
mysql  <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
CREATE USER 'mgrosmann'@'localhost' IDENTIFIED BY 'password';
CREATE DATABASE test;
GRANT ALL PRIVILEGES ON test.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
EOF
