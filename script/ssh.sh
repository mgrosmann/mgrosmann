#!/bin/bash
ssh-keygen -t rsa -b 2048 
ssh-copy-id -i ~/.ssh/id_rsa.pub user@192.168.1.AAA
ssh-copy-id -i ~/.ssh/id_rsa.pub user@192.168.1.BBB





#1. **Sur la machine principale (Machine A) :
#1. Générer une paire de clés SSH (sans passphrase) : ssh-keygen -t rsa -b 2048 
#puis verifier avec ls ~/.ssh
#ssh-copy-id -i ~/.ssh/id_rsa.pub user@192.168.1.AAA
#ssh-copy-id -i ~/.ssh/id_rsa.pub user@192.168.1.BBB
#2. puis sur les deux autres machines
#user@192.168.1.AAA
#ssh-keygen -t rsa -b 2048
#ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@192.168.1.100
#user@192.168.1.BBB
#ssh-keygen -t rsa -b 2048
#ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@192.168.1.100