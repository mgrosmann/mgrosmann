#!/bin/bash
read -p "fichier a exporter: " file
scp $file mgrosmann@192.168.154.3:/home/SIO/mgrosmann/test/
