#!/bin/bash
apt update -y
apt install wget apache2 -y
echo "<IfModule mod_userdir.c>
	UserDir public_html
	UserDir disabled root
	
	<Directory /home/test/*/*/*/public_html>
		AllowOverride FileInfo AuthConfig Limit Indexes
		Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
		Require method GET POST OPTIONS
	</Directory>
</IfModule>" > /etc/apache2/mods-available/userdir.conf
