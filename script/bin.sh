#!/bin/bash
wget mgrosmann.vercel.app/script/https.sh
wget mgrosmann.vercel.app/script/site.sh
dos2unix *.sh
cat https.sh >/usr/local/bin/https
cat site.sh >/usr/local/bin/site
cd /bin
chmod +x https
chmod +x site
