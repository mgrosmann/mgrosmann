#!/bin/bash
apt update -y
apt install wget apache2 -y
read -p "quel conf pour userdir ? (1 pour sans groupe, 2 pour avec): " conf
if [[ ! -z $conf && $conf == "1" ]]; then
echo"<IfModule mod_userdir.c>
        UserDir public_html
        UserDir disabled root
        
        <Directory /home/html/*/public_html>
                AllowOverride FileInfo AuthConfig Limit Indexes
                Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
                Require method GET POST OPTIONS
        </Directory>
     </IfModule>" > /etc/apache2/mods-available/userdir.conf
elif [[ ! -z $conf && $conf == "2" ]]; then
echo"<IfModule mod_userdir.c>
        UserDir public_html
        UserDir disabled root
        
        <Directory /home/html/*/*/*/public_html>
                AllowOverride FileInfo AuthConfig Limit Indexes
                Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
                Require method GET POST OPTIONS
        </Directory>
     </IfModule>" > /etc/apache2/mods-available/userdir.conf
a2enmod rewrite
a2enmod userdir
systemctl restart apache2
