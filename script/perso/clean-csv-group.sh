#!/bin/bash
csv="/mnt/c/Users/PC/Downloads/group.csv"
home="/home/html"
tail -n +2 $csv | while IFS=',' read -r id nom prenom; do #lit le csv ligne par ligne
	groupdel -f $pays 2> /dev/null
	groupdel -f $region 2> /dev/null
	userdel -f $yusername 2> /dev/null
rm -rf /home/html/
rm -rf /var/www/html/user.html
