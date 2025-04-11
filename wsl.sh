#!/bin/bash
mkdir -p /root/bin
echo "#!/bin/bash" > /root/bin/hw
echo "echo 'hello world !!!'" >> /root/bin/hw
chmod +x /root/bin/*
echo " PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /root/.bashrc
echo "export PATH=$PATH:/root/bin" >> /root/.bashrc
ln -s /mnt/c/Users/PC/Documents /root/doc
ln -s /mnt/c/Users/PC/Downloads /root/telechargements
ln -s /mnt/c/Users/PC/Videos /root/videos
apt update -y
apt install apache2 php-mysql libapache2-mod-php ssh git zip python3 -y
wget mgrosmann.vercel.app/script/projet/mysql.sh
bash mysql.sh
wget mgrosmann.vercel.app/autres/dump.sql
mysql -uroot -proot < dump.sql
rm /var/www/html/index.html
wget mgrosmann.vercel.app/autres/html.zip
unzip html.zip -d /usr/share
mv /usr/share/html /usr/share/web
ln -s /usr/share/web /root/web
cat << EOF < /var/www/html/index.php
<?php
  header('Location: /web');
  exit();
?>
EOF
echo "Alias /web /usr/share/web" > /etc/apache2/conf-available/web.conf
a2enconf web
systemctl reload apache2
rm html*
git clone https://github.com/mgrosmann/docker.git
git clone https://github.com/mgrosmann/mgrosmann.git
cp -r mgrosmann  /var/www/html/portfolio/
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
ssh-copy-id -i ~/.ssh/id_rsa.pub -p1622 mgrosmann@sio.jbdelasalle.com
ssh-copy-id -i ~/.ssh/id_rsa.pub -o ProxyJump=mgrosmann@sio.jbdelasalle.com:1622 root@192.168.182.1
ssh-copy-id -i ~/.ssh/id_rsa.pub -o ProxyJump=mgrosmann@sio.jbdelasalle.com:1622,root@192.168.182.1 admin@192.168.182.213
ssh-copy-id -i ~/.ssh/id_rsa.pub -o ProxyJump=mgrosmann@sio.jbdelasalle.com:1622,root@192.168.182.1,admin@192.168.182.213 root@192.168.1.11
echo "pensez à faire 'source ~/.bashrc' pour activer le repertoire /root/bin"
