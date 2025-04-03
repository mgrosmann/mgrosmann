#!/bin/bash
read -p "réseau sio ou pas (1 pour non, 2 pour oui) " sio
if [[ $sio == 1 ]]; then
    ssh -L 8008:192.168.184.1:8006 \
        -L 8200:192.168.1.1:443 \
        -L 33891:192.168.1.10:3389 \
        -J mgrosmann@sio.jbdelasalle.com:1622,root@192.168.184.1,admin@192.168.184.20 root@192.168.1.104
elif [[ $sio == 2 ]]; then
    ssh -L 8008:192.168.184.1:8006 \
        -L 8200:192.168.1.1:443 \
        -L 33891:192.168.1.10:3389 \
        -J root@192.168.184.1,admin@192.168.184.20 root@192.168.1.104
else
    echo "choix incorrect"
fi
