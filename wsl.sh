#!/bin/bash
ln -s /mnt/c/Users/PC/Documents /root/doc
ln -s /mnt/c/Users/PC/Downloads /root/telechargements
ln -s /mnt/c/Users/PC/Videos /root/videos
apt update
apt install apache2 libapache2-mod-php -y
rm -rf /var/www/html/
cp -r /root/doc/htdocs /var/www/html
cd /root
wget mgrosmann.vercel.app/script/perso/jump.sh
wget mgrosmann.vercel.app/script/perso/sio_jump.sh
