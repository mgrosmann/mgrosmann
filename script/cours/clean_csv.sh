#!/bin/bash

tmp_directory="/tmp/yankrider_data"
file_sites="test_sites.csv"
file_users="test_users.csv"

echo "Mode de nettoyage (test / complet) ?"
read reponse

# Si la réponse n'est pas NULL et est égale à "complet"
if [[ ! -z $reponse && $reponse == "complet" ]]; then
	file_sites="sites.csv"
	file_users="users.csv"
fi


while IFS=";" read -r code id address postal_code city state state_code; do

	echo "Suppression du groupe "$state_code
	groupdel -f $state_code 2> /dev/null
	
	echo "Suppression du groupe "$code
	groupdel -f $code 2> /dev/null
	
done < <(tail -n +2 $tmp_directory/$file_sites)


while IFS=";" read -r id first_name last_name gender email function hiring_date	site; do
	echo "Suppression de l'utilisateur "$email
	userdel -f $email 2> /dev/null
done < <(tail -n +2 $tmp_directory/$file_users)


echo "Suppression des dossiers de Yankrider"
rm -rf $tmp_directory
rm -rf /home/yankrider
rm -rf /var/www/html/index.html
