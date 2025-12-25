#!/bin/bash
echo 'mkdir -p /tmp/fernet/
file=$(mktemp)
genkey=$(mktemp)
echo "from cryptography.fernet import Fernet
fernet_key = Fernet.generate_key()
print(fernet_key.decode())" > $genkey
for i in {1..10}; do python3 $genkey >> $file && wc -l $file ; done
mv $file /tmp/fernet/
echo "$file terminé"' > fernet-key.sh
for i in {1..100}; do bash fernet-key.sh ; done
