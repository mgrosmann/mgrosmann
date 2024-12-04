#!/bin/bash
for file in *.yaml
do 
    docker compose -f "$file" stop
  else
    echo "Aucun fichier .yaml trouvé."
  fi
done
