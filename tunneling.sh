#182.1
#!/bin/bash
read -p "réseau sio ou pas (1 pour non, 2 pour oui) " sio
if [[ $sio == 1 ]]; then
    ssh -L 8006:192.168.182.1:8006 \
        -L 33890:192.168.1.10:3389 \
        -L 4430:192.168.1.1:443 \
        -L 2222:192.168.1.11:22 \
        -L 8000:192.168.1.11:80 \
        -J mgrosmann@sio.jbdelasalle.com:1622,root@192.168.182.1,admin@192.168.182.213 root@192.168.1.11
elif [[ $sio == 2 ]]; then
    ssh -L 8006:192.168.182.1:8006 \
        -L 33890:192.168.1.10:3389 \
        -L 4430:192.168.1.1:443 \
        -L 2222:192.168.1.11:22 \
        -L 8000:192.168.1.11:80 \
        -J root@192.168.182.1,admin@192.168.182.213 root@192.168.1.11
else
    echo "choix incorrect"
fi
#184.1
#!/bin/bash
read -p "réseau sio ou pas (1 pour non, 2 pour oui) " sio
if [[ $sio == 1 ]]; then
    ssh -L 8008:192.168.184.1:8006 \
        -L 8200:192.168.1.1:443 \
        -L 33891:192.168.1.10:3389 \
        -J mgrosmann@sio.jbdelasalle.com root@192.168.184.1,admin@192.168.184.20 root@192.168.1.104
elif [[ $sio == 2 ]]; then
    ssh -L 8008:192.168.184.1:8006 \
        -L 8200:192.168.1.1:443 \
        -L 33891:192.168.1.10:3389 \
        -J root@192.168.184.1,admin@192.168.184.20 root@192.168.1.104
else
    echo "choix incorrect"
fi
