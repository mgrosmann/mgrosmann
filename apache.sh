#!/bin/bash
read -p "quel nom pour votre user: " user
mkdir -p /home/html/
useradd $user -m -d /home/html/$user
mkdir /home/html/$user/perso_html
chown -R $user /home/html/$user
echo "coucou bienvenue sur le site de moi, $user" > /home/html/$user/perso_html/index.html
cat << EOF > /etc/apache2/mods-available/userdir.conf
<IfModule mod_userdir.c>
	UserDir perso_html
	UserDir disabled root
	
	<Directory /home/html/*/perso_html>
		AllowOverride FileInfo AuthConfig Limit Indexes
		Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
		Require method GET POST OPTIONS
	</Directory>
</IfModule>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
#path = 
#a2enmod userdir puis systemctl restart apache2
EOF
a2enmod userdir
a2enmod rewrite
systemctl restart apache2
echo "le 'systemctl restart apache2' a deja ete effectuer par le script, votre site est disponible sur http://localhost/~user"
