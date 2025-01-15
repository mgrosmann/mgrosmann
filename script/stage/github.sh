#!/bin/bash
if ! command -v dos2unix &> /dev/null
then
    echo "dos2unix n'est pas installé. Installation en cours..."
    sudo apt-get install -y dos2unix
else
    echo "dos2unix est déjà installé."
fi
if ! command -v git &> /dev/null
then
    echo "git n'est pas installé. Installation en cours..."
    sudo apt-get install -y git
else
    echo "git est déjà installé."
fi
git clone https://github.com/mgrosmann/mgrosmann.git
