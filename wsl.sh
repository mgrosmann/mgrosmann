#!/bin/bash
ln -s /mnt/c/Users/PC/Documents /root/doc
ln -s /mnt/c/Users/PC/Downloads /root/telechargements
ln -s /mnt/c/Users/PC/Videos /root/videos
apt update
apt install apache2 libapache2-mod-php ssh git zip -y
rm -rf /var/www/html/
cp -r /root/doc/htdocs /var/www/html
cd /root
wget mgrosmann.vercel.app/script/perso/jump.sh
wget mgrosmann.vercel.app/script/perso/sio_jump.sh
wget mgrosmann.vercel.app/autres/html.zip
wget mgrosmann.vercel.app/autres/html.z01
wget mgrosmann.vercel.app/autres/html.z02
unzip html.zip -d /var/www
rm html.zip
git clone https://github.com/mgrosmann/docker.git
git clone https://github.com/mgrosmann/mgrosmann.git
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
ssh-copy-id -i ~/.ssh/id_rsa.pub -p1622 mgrosmann@sio.jbdelasalle.com
ssh-copy-id -i ~/.ssh/id_rsa.pub -o ProxyJump=mgrosmann@sio.jbdelasalle.com:1622 root@192.168.182.1
ssh-copy-id -i ~/.ssh/id_rsa.pub -o ProxyJump=mgrosmann@sio.jbdelasalle.com:1622,root@192.168.182.1 admin@192.168.182.213
ssh-copy-id -i ~/.ssh/id_rsa.pub -o ProxyJump=mgrosmann@sio.jbdelasalle.com:1622,root@192.168.182.1, admin@192.168.182.213, root@192.168.1.118
