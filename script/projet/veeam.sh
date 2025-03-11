#!/bin/bash
wget https://repository.veeam.com/backup/linux/agent/dpkg/debian/public/pool/veeam/v/veeam-release-deb/veeam-release-deb_1.0.9_amd64.deb
apt-get install veeam-release-deb_1.0.9_amd64.deb
apt-get install veeam
echo "effectuez 'veeamconfig ui' pour vérifier si l'installation a réussi"