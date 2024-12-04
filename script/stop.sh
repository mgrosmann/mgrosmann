#!/bin/bash
for file in *.yaml; do
  if [ -f "$file" ]; then
    echo "Arrêt des services définis dans $file"
    docker compose -f "$file" stop
  else
    echo "Aucun fichier .yaml trouvé."
  fi
done
