#!/bin/bash
touch "$2"
cat "$1" | tr -d '\r' > "$2"  
echo "Conversion terminée : $2"
