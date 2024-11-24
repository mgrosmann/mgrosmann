#!/bin/bash

# Générer la clé SSH sans mot de passe et la sauvegarder dans /root/ssh.txt
ssh-keygen -t rsa -b 2048 -f /root/ssh.txt -N ""

# Copier la clé publique vers les machines distantes
ssh-copy-id -i /root/ssh.txt.pub mgrosmann@192.168.1.110
ssh-copy-id -i /root/ssh.txt.pub mgrosmann@192.168.1.111
