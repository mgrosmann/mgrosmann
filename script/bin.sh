#!/bin/bash
wget mgrosmann.vercel.app/script/https.sh
wget mgrosmann.vercel.app/script/site.sh
apt install dos2unix
dos2unix *.sh
cat https.sh >/bin/https
cat site.sh >/bin/site
cd /bin
chmod +x *
