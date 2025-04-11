#!/bin/bash
sites="test_sites.csv"
user="test_users.csv"
tmp="/tmp/test"
home="/home/test"
read -p "Mode d'initialisation (complet 1 / test 2) ?" reponse
if [[ ! -z $reponse && $reponse == "1" ]]; then
	sites="sites.csv"
	user="users.csv"
fi
mkdir $tmp
mkdir $home
echo "Récupération des données des sites"
wget -P $tmp https://sio.jbdelasalle.com/~bdufour/TP/yankrider_data/$sites
while IFS=";" read -r code id address postal_code city state state_code; do
	state_path=$home/$state_code
	if [ ! -d $state_path ]; then
		echo "Création du répertoire de l'état "$state
		mkdir $state_path
		echo "Création du groupe de l'état "$state
		groupadd -f $state_code
	fi
	if [ ! -d $state_path/$code ]; then
		echo "Création du répertoire du site "$code
		mkdir $state_path/$code
		echo "Création du groupe du site "$code
		groupadd -f $code
	fi
done < <(tail -n +2 $tmp/$sites)
echo "Récupération des données des utilisateurs"
wget -P $tmp https://sio.jbdelasalle.com/~bdufour/TP/yankrider_data/$user
echo "Création de l'annuaire des utilisateurs"
echo "<!DOCTYPE html>
<html lang='fr'>
	<head>
		<meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
		<title>Titre de votre page WEB</title>
	</head>
	<body>" > /var/www/html/user.html
while IFS=";" read -r id first_name last_name gender email function hiring_date	site; do
	state_code=$(echo $site | cut -c3-)
	path_user_home=$home/$state_code/$site/$email
	path_user_public_html=$path_user_home"/public_html"
	echo "Création du compte utilisateur pour "$first_name" "$last_name
	useradd $email -m -d $path_user_home
	echo "Modification du mot de passe de "$first_name" "$last_name" pour btssio"
	echo $email:btssio | chpasswd
	echo "Ajout de "$first_name" "$last_name" dans les groupes "$state_code" et "$site
	usermod -aG www-data,$state_code,$site $email
	echo "Création de public_html pour "$first_name" "$last_name
	mkdir $path_user_public_html
	chmod -R 755 $path_user_home
	echo "Création de index.html pour "$first_name" "$last_name
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
	echo "Ajout de "$first_name" "$last_name" dans l'annuaire"
	echo "<div><a href='~"$email"/index.html'>"$first_name" "$last_name"</a></div>" >> /var/www/html/user.html
	echo "Mise à jour des droits de index.html de "$first_name" "$last_name
	chmod 755 $path_user_public_html"/index.html"
done < <(tail -n +2 $tmp/$user)
echo '</body>
</html>' >> /var/www/html/user.html