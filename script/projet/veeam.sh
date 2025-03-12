#!/bin/bash
wget https://download2.veeam.com/VAL/v6/veeam-release-deb_1.0.9_amd64.deb
dpkg -i ./veeam-release* && apt-get update
apt-get install blksnap veeam -y
apt-get installe veeam-nosnap -y
echo "effectuez 'veeamconfig ui' pour vérifier si l'installation a réussi"