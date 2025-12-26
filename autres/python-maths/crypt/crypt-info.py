crypt data with ccrypt
ccrypt -b -r -e -S .crypt *
ccrypt -b -r -d -S .crypt *
#-s pour interdire double cryptage
#################################crypt with python and fernet#################################
tar -cvf media.tar /media/txt/
#generate the key
from cryptography.fernet import Fernet
fernet_key = Fernet.generate_key()
print(fernet_key.decode()) 
###################encrypt the tar archive####################
from cryptography.fernet import Fernet
# Load the key from the .key file
#key = input("Entrez la clé : ")
with open('key', 'rb') as filekey:
 key = filekey.read()
# Create a Fernet object using the key
fernet = Fernet(key)
# Open the file to be encrypted in binary read mode
with open('media.tar', 'rb') as f:
    original = f.read()
# Encrypt the file content
encrypted = fernet.encrypt(original)
# Overwrite the original file with the encrypted data
with open('media.tar', 'wb') as f:
    f.write(encrypted)
#decrypt the tar archivee################################
from cryptography.fernet import Fernet
# Load the key again
#key= input("Entrez la clé : ")
with open('key', 'rb') as filekey:
 key = filekey.read()
# Create a Fernet object
fernet = Fernet(key)
# Read the encrypted data from the file
with open('media.tar', 'rb') as f:
    encrypted = f.read()
# Decrypt the encrypted data
decrypted = fernet.decrypt(encrypted)
# Write the decrypted data back to the file
with open('media.tar', 'wb') as f:
    f.write(decrypted)
#####generer une chaine aléatoire, head -c x pour déterminer la longueur de la chaine##########################""
random=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 10; echo)
##################"tout sacoir sur head tail
#retourner nombre de ligne
wc -l totalkey
#afficher ligne first
head -n1 total_key
#afficher derniere ligne
tail -n1 total_key
#afficher la x ligne en partant du haut
head -nx total_key | tail -n1
#afficher la x ligne en partant du bas
tail -nx total_key | head -n1
#afficher de la ligne x a y
head -ny total_key | tail -n(y-x)+1
#exemple de 7 a 20
head -n20 number | tail -n14
