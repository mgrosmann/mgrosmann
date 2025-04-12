#!/bin/bash
csv="/mnt/c/Users/PC/Downloads/user.csv"
home="/home/html"
tail -n +2 $csv | while IFS=',' read -r id nom prenom; do #lit le csv ligne par ligne
	userdel -f $yusername 2> /dev/null
rm -rf /home/html/
rm -rf /var/www/html/user.html
done
