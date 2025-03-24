#!/bin/bash
git config --global user.name "mgrosmann"
git config --global user.email "grosmannmatheo@gmail.com"
git config --global url."git@github.com:".insteadOf "https://github.com/"
read -p "Quel repository ? " repo
if [ -d "$repo" ]; then
    echo "Le dossier '$repo' existe déjà, pas besoin de cloner."
else
    git clone git@github.com:mgrosmann/$repo.git || { echo "Échec du clonage."; exit 1; }
fi
cd "$repo"
read -p "Quel fichier à ajouter ? " file
read -rp "Quel dossier du repository ? (laisser vide pour la racine) " folder
cp "$file" "$folder/"
git add .
git commit -m "Ajout/update de '$file' dans '$folder'"
git push origin main || { echo "Échec du push."; exit 1; }
cd ..
rm -rf "$repo"
echo "Fichiers envoyés avec succès sur GitHub via SSH ! ✅"