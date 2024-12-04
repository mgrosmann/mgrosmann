#!/bin/bash
read -p "sur quel conteneur voulez vous appliquez des commandes linux" name
  docker cp "/bin/wget" "$name:/bin"
  docker cp "/bin/touch" "$name:/bin"
  docker cp "/bin/nano" "$name:/bin"
