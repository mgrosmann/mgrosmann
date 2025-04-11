#!/bin/bash
user="test_users.csv"
tmp="/tmp/test"
home="/home/test"
read -p "Mode d'initialisation (complet 1 / test 2) ?" reponse
if [[ ! -z $reponse && $reponse == "1" ]]; then
	user="users.csv"
fi
mkdir -p $tmp
mkdir -p $home
#echo "Récupération des données des sites"
wget -P $tmp https://sio.jbdelasalle.com/~bdufour/TP/yankrider_data/$user
#echo "Création de l'annuaire des utilisateurs"
echo "<!DOCTYPE html>
<html lang='fr'>
	<head>
		<meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
		<title>Titre de votre page WEB</title>
	</head>
	<body>" > /var/www/html/user.html
while IFS=";" read -r id first_name last_name gender email function hiring_date	site; do
	path_user_home=$home/$email
	path_user_public_html=$path_user_home"/public_html"
	#echo "Création du compte utilisateur pour "$first_name" "$last_name
	useradd $email -m -d $path_user_home
	#echo "Modification du mot de passe de "$first_name" "$last_name" pour btssio"
	echo $email:root | chpasswd
	#echo "Ajout de "$first_name" "$last_name" dans les groupes "$state_code" et "$site
	usermod -aG www-data,$email
	#echo "Création de public_html pour "$first_name" "$last_name
	mkdir -p $path_user_public_html
	chmod -R 755 $path_user_home
	#echo "Création de index.html pour "$first_name" "$last_name
	echo "<!DOCTYPE html>
	<html lang='fr'>
		<head>
			<meta charset='utf-8'>
			<meta name='viewport' content='width=device-width, initial-scale=1'>
			<title>"$first_name" "$last_name"</title>
		</head>
		<body>
			"$first_name" "$last_name"
		</body>
	</html>" > $path_user_public_html"/index.html"
	#echo "Ajout de "$first_name" "$last_name" dans l'annuaire"
	echo "<div><a href='~"$email"/index.html'>"$first_name" "$last_name"</a></div>" >> /var/www/html/user.html
	#echo "Mise à jour des droits de index.html de "$first_name" "$last_name
	chmod 755 $path_user_public_html"/index.html"
done < <(tail -n +2 $tmp/$user)
echo '</body>
</html>' >> /var/www/html/user.html
