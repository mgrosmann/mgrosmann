#!/bin/bash
correct=$(ls total_key* > /tmp/len && cat /tmp/len | wc -m)
decrypt=$(mktemp)
#read -p \"fichier a decrypter\" file
ikey=$(mktemp)
file=$1
key_file="/root/total_key"
#read -s key
echo "from cryptography.fernet import Fernet
# Load the key again
#key= input(\"Entrez la clé : \")
with open('$ikey', 'rb') as filekey:
    key = filekey.read()
#key = \'$key\'
# Create a Fernet object
fernet = Fernet(key)
# Read the encrypted data from the file
with open('$file', 'rb') as f:
    encrypted = f.read()
# Decrypt the encrypted data
decrypted = fernet.decrypt(encrypted)
# Write the decrypted data back to the file
with open('$file', 'wb') as f:
    f.write(decrypted)" > $decrypt
while (($correct!=10)) #tant que total_key pas été décrypté, decrypte et reset la variable correct
do
        ccrypt -b -r -d -S .crypt total_key*
        correct=$(ls total_key* > /tmp/len && cat /tmp/len | wc -m)
done
number=$(cat total_key | wc -l )
for i in {1..10} # tail supprte pas les variables il faut définir manuellement la valeur dans for i in
do
        tail -n"$i" total_key | head -n1 > $ikey
        python3 $decrypt
done
rm $decrypt
echo "le fichier $file a été décrypté"
