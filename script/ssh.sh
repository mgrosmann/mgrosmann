#!/bin/bash
ssh-keygen -t rsa -b 2048
ssh-copy-id -i /root/ssh.txt.pub mgrosmann@192.168.1.110
ssh-copy-id -i /root/ssh.txt.pub mgrosmann@192.168.1.111
