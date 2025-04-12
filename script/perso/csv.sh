#!/bin/bash
#la synatxe du csv doit être : id,nom,prenom tel que 
#seq,name/last,name/first | id,nom,prenom dans https://www.convertcsv.com/generate-test-data.htm
csv="/mnt/c/Users/PC/Downloads/user.csv"
home="/home/html"
mkdir -p "$home"
echo "<!DOCTYPE html>
<html lang='fr'>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Titre de votre page WEB</title>
</head>
<body>" > /var/www/html/user.html	
tail -n +2 "$csv" | while IFS=',' read -r id nom prenom; do
    id1=$(echo "$prenom" | cut -c 1)
    username=${id1}${nom}
    user_home="$home/$username"
    public_html="$user_home/public_html"
    index_file="$public_html/index.html"
    if id "$username" &>/dev/null; then
        echo "Utilisateur $username existe déjà, on passe."
        continue
    fi
    useradd -m -d "$user_home" "$username"
    echo "$username:root" | chpasswd
    usermod -aG www-data "$username"
    mkdir -p "$public_html"
    echo "Espace web de $prenom $nom" > "$index_file"
    chmod 755 "$index_file"
    chmod -R 755 "$user_home"
    echo "Ajout de $prenom $nom dans l'annuaire"
    echo "<div><a href='~$username/index.html'>$prenom $nom</a></div>" >> /var/www/html/user.html
    echo "Utilisateur $username créé avec succès."
done
echo '</body>
</html>' >> /var/www/html/index.html
