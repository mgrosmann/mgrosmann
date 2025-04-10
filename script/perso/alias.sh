#!/bin/bash
for folder in /root/web/; do
  if [ ! -f /path/to/file ]
  then
    cat << EOF > /etc/apache2/conf-available/${folder}.conf
    Alias /$folder /usr/share/$folder
    EOF
a2enconf ${folder}.conf
systemctl restart apache2
