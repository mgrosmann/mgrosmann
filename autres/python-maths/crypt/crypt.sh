#!/bin/bash
if [ -z "$file" ]; then
    echo "Usage: $0 <file_to_encrypt> retry with a file to encrypt"
    exit 1
fi
genkey=/tmp/genkey.py
newkey=/tmp/newkey.key
crypt=/tmp/crypt.py
file=$1
echo "from cryptography.fernet import Fernet
fernet_key = Fernet.generate_key()
print(fernet_key.decode())" > $genkey
echo "from cryptography.fernet import Fernet
# Load the key from the .key file
#key = input("Entrez la clé : ")
with open('$newkey', 'rb') as filekey:
    key = filekey.read()
# Create a Fernet object using the key
fernet = Fernet(key)
# Open the file to be encrypted in binary read mode
with open('$file', 'rb') as f:
    original = f.read()
# Encrypt the file content
encrypted = fernet.encrypt(original)
# Overwrite the original file with the encrypted data
with open('$file', 'wb') as f:
    f.write(encrypted)" > $crypt
for i in {1..10} #crypter avec fernet x nombre de fois
do
    clef=$(python3 /tmp/genkey.py) && echo $clef > $newkey
    echo $clef >> total_key
    #crypt the file with the new key
    python3 $crypt
    echo "Encryption pass $i done."
done
#delete key used and python script
rm $genkey $crypt $newkey
#crypter x fois avec ccrypt
for i in {1..3}; do ccrypt -b -r -e -S .crypt total_key*; done
#send to usb drive if exist
#mv total_key* /mnt/d
