#!/bin/bash
wget https://mgrosmann.onrender.com/script/projet/proxy.sh
chmod +x proxy.sh
bash proxy.sh
wget https://mgrosmann.onrender.com/script/projet/captif.sh
chmod +x captif.sh
bash captif.sh
git clone https://github.com/mgrosmann/mgrosmann.git
git clone https://github.com/mgrosmann/docker.git
