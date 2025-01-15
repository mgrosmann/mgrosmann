#!/bin/bash
if ! command -v apache2 &> /dev/null
then
    echo "apache2 n'est pas installé. Installation en cours..."
    sudo apt-get update
    sudo apt-get install -y apache2
else
    echo "apache2 est déjà installé."
fi
if ! command -v dos2unix &> /dev/null
then
    echo "dos2unix n'est pas installé. Installation en cours..."
    sudo apt-get install -y dos2unix
else
    echo "dos2unix est déjà installé."
fi
chmod +x /*.sh
dos2unix *.sh
for script in *.sh
do
  mv "$script" "/usr/local/bin/$(basename "$script" .sh)"
done
rm /usr/local/bin/bin.sh
