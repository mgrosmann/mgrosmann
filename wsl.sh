#!/bin/bash
mkdir -p /root/bin
echo "#!/bin/bash" > /root/bin/hello-world
echo "echo 'hello world !!!'" >> /root/bin/hello-world
wget mgrosmann.vercel.app/script/perso/jump.sh
wget mgrosmann.vercel.app/script/perso/david.sh
mv jump.sh /root/bin/jump
mv david.sh /root/bin/david
chmod +x /root/bin/*
echo "export PATH=$PATH:/root/bin" >> /root/.bashrc
source .bashrc
ln -s /mnt/c/Users/PC/Documents /root/doc
ln -s /mnt/c/Users/PC/Downloads /root/telechargements
ln -s /mnt/c/Users/PC/Videos /root/videos
apt update
apt install apache2 php-mysql libapache2-mod-php ssh git zip -y
wget mgrosmann.vercel.app/script/projet/mysql.sh
bash mysql.sh
mysql -uroot -p$pass < /root/doc/all-databases-202503311246.sql
wget mgrosmann.vercel.app/autres/html.zip
wget mgrosmann.vercel.app/autres/html.z01
wget mgrosmann.vercel.app/autres/html.z02
zip -FF html.zip --out html_complete.zip
unzip html_complete.zip -d /var/www
rm html*
git clone https://github.com/mgrosmann/docker.git
git clone https://github.com/mgrosmann/mgrosmann.git
cp -r mgrosmann /var/www/html/portfolio
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
ssh-copy-id -i ~/.ssh/id_rsa.pub -p1622 mgrosmann@sio.jbdelasalle.com
ssh-copy-id -i ~/.ssh/id_rsa.pub -o ProxyJump=mgrosmann@sio.jbdelasalle.com:1622 root@192.168.182.1
ssh-copy-id -i ~/.ssh/id_rsa.pub -o ProxyJump=mgrosmann@sio.jbdelasalle.com:1622,root@192.168.182.1 admin@192.168.182.213
ssh-copy-id -i ~/.ssh/id_rsa.pub -o ProxyJump=mgrosmann@sio.jbdelasalle.com:1622,root@192.168.182.1,admin@192.168.182.213 root@192.168.1.11
