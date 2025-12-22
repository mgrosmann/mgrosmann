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
