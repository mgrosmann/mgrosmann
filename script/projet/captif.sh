#!/bin/bash
read -p "entrer l'url: " url
read -p "entrer le user: " user
read -p "entrer le password: " passwd 
curl --request POST --data "user=$user&cmd=authenticate&password=$passwd" ''$url''
