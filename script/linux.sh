#!/bin/bash
read -p "sur quel conteneur voulez vous appliquez des commandes linux" name
  docker cp "/bin/wget" "$name:/bin"
  docker cp "/bin/touch" "$name:/bin"
  docker cp "/bin/nano" "$name:/bin"
chmod +x wget
chmod +x touch
chmod +x nano
echo "Commandes linux copiées avec succès dans le conteneur $name"