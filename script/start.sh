#!/bin/bash
for file in *.yaml
do 
    docker compose -f "$file" start
  else
    echo "Aucun fichier .yaml trouvé."
  fi
done
