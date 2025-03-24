#!/bin/bash
git config --global user.name "mgrosmann"
git config --global user.email "grosmannmatheo@gmail.com"
git config --global url."git@github.com:".insteadOf "https://github.com/"
git add .
git commit -m "fichier importé par ssh en linux"
git push origin main || { echo "Échec du push."; exit 1; }
echo "Fichiers envoyés avec succès sur GitHub via SSH ! ✅"
