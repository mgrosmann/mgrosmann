#!/bin/bash
read -p "Entrez le repertoire du fichier a importer : " file
scp -P 1622 mgrosmann@sio.jbdelasalle.com:/home/SIO/mgrosmann/pictures/fv/linux/$file /home/bazar