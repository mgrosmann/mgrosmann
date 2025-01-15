#!/bin/bash
apt update && apt upgrade
apt autoremove && apt autoclean
ufw default allow outgoing
ufw default deny incoming
ufw allow 22
ufw allow 80
ufw allow 443
ufw enable
ufw status
apt install apache2 mariadb-server libapache2-mod-php php php-gmp php-bcmath php-gd php-json php-mysql php-curl php-mbstring php-intl php-imagick php-xml php-zip php-fpm php-apcu php-opcache bzip2 zip unzip imagemagick vim libimage-exiftool-perl ffmpeg
a2enconf php8.1-fpm
a2dismod php8.1
a2dismod mpm_prefork
a2enmod mpm_event
a2enmod ssl rewrite headers deflate cache http2 proxy_fcgi env expires
systemctl restart apache2
systemctl enable apache2
systemctl enable php8.1-fpm
systemctl enable mariadb
#!/bin/bash
DB_USER="root"
DB_PASSWORD="root"
mysql -u $DB_USER -p$DB_PASSWORD -e "CREATE USER 'piwigo'@'localhost' IDENTIFIED BY 'piwigo';"
mysql -u $DB_USER -p$DB_PASSWORD -e  "CREATE DATABASE piwigo;"
mysql -u $DB_USER -p$DB_PASSWORD -e  "GRANT ALL PRIVILEGES ON piwigo.* TO 'piwigo'@'localhost';"
mysql -u $DB_USER -p$DB_PASSWORD -e  "FLUSH PRIVILEGES;"
mkdir -p /var/www/piwigo
cat <<EOF > /etc/apache2/sites-available/piwigo.conf
<VirtualHost *:8000>
	ServerName DOMAIN.COM
	DocumentRoot /var/www/piwigo

	<Directory "/var/www/piwigo">
		AllowOverride All
		Options -Indexes +FollowSymLinks
	</Directory>

	ErrorLog /var/log/apache2/piwigo_error.log
</VirtualHost>
EOF
a2dissite 000-default.conf
a2ensite piwigo.conf
apachectl -t
systemctl restart apache2
cd /var/www
wget https://github.com/Piwigo/Piwigo/archive/refs/tags/13.7.0.zip
unzip 13.7.0.zip
rm /var/www/html/index.html
shopt -s dotglob
mv Piwigo-13.7.0/* piwigo/
chown -R www-data:www-data /var/www/piwigo
echo "nano /etc/php/8.1/fpm/php.ini
max_execution_time = 180 (line 409)
memory_limit = 512M (line 430)
post_max_size = 200M (line 698)
upload_max_filesize = 200M (line 850)
systemctl restart php8.1-fpm"