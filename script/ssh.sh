#!/bin/bash
ssh-keygen -t rsa -b 2048 -f /root/ssh.txt
ssh-copy-id -i /root/ssh.txt.pub user@192.168.1.AAA
ssh-copy-id -i /root/ssh.txt.pub user@192.168.1.BBB