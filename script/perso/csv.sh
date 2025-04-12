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
<body>" > /var/www/html/user.html #creation de l'annuaire user.html
tail -n +2 "$csv" | while IFS=',' read -r id nom prenom; do #lit le csv ligne par ligne
    test=$(echo $prenom | cut -c 1 | tr '[:upper:]' '[:lower:]') #pour creer un login premier lettre du prenom suivi du nom et forcer en minuscule
    test1=$(echo $nom | tr '[:upper:]' '[:lower:]')
    username=${test}${test1}
    user_home="$home/$username"
    public_html="$user_home/public_html"
    index_file="$public_html/index.html"
    if ! id "$username" &>/dev/null; then #si une manip foire et que le script doit etre reexcecuté, on skippe la creation de l'utilisateur mais on execute le reste pour etre sur que le reste de la config soit effectué
        useradd "$username" -m -d "$user_home"
        echo "$username:root" | chpasswd
        usermod -aG www-data "$username"
    fi
    mkdir -p "$public_html"
    echo "Espace web de $prenom $nom" > "$index_file" #creation d'un index.html par défaut
    chmod 755 "$index_file"
    chmod -R 755 "$user_home"
    echo "<div><a href='~$username/index.html'>$prenom $nom</a></div>" >> /var/www/html/user.html #ajout du $user dans l'annuaire user.html
    echo "repertoire web de l'utilisateur $username n°$id créé avec succès."
done
echo '</body>
</html>' >> /var/www/html/user.html
