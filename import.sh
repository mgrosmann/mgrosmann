#!/bin/bash
read -p "fichier a exporter: " file
scp mgrosmann@192.168.154.3:/home/SIO/mgrosmann/$file
