#!/bin/bash
user="test_users.csv"
tmp="/tmp/test"
home="/home/test"
read -p "Mode d'initialisation (complet 1 / test 2) : " reponse
if [[ ! -z $reponse && $reponse == "1" ]]; then
	user="users.csv"
fi
mkdir -p $tmp
mkdir -p $home
wget -P $tmp https://sio.jbdelasalle.com/~bdufour/TP/yankrider_data/$user
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
	useradd $email -m -d $path_user_home
	echo $email:root | chpasswd
	usermod -aG www-data,$email
	mkdir -p $path_user_public_html
	chmod -R 755 $path_user_home
	echo "<!DOCTYPE html>
	<html lang='fr'>
		<head>
			<meta charset='utf-8'>
			<meta name='viewport' content='width=device-width, initial-scale=1'>
			<title>"$email"</title>
		</head>
		<body>
			espace web de "$email"
		</body>
	</html>" > $path_user_public_html"/index.html"
	echo "<div><a href='~"$email"/index.html'>"$first_name" "$last_name"</a></div>" >> /var/www/html/user.html
	chmod 755 $path_user_public_html"/index.html"
done < <(tail -n +2 $tmp/$user)
echo '</body>
</html>' >> /var/www/html/user.html
