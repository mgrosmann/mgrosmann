#!/bin/bash
if [ $2 -eq "EquipeD" ]; then
  deluser $1 $2
  deluser $1 projetG
  deluser $1 projetI
  deluser $1 GroupG
  deluser $1 GroupI
fi
if [ $2 -eq "EquipeE" ]; then
  deluser $1 $2
  deluser $1 projetG
  deluser $1 projetH
  deluser $1 GroupG
  deluser $1 GroupH
fi
if [ $2 -eq "EquipeF" ]; then
  deluser $1 $2
  deluser $1 projetH
  deluser $1 projetI
  deluser $1 GroupH
  deluser $1 GroupI
fi
if [ $3 -eq "EquipeD" ]; then
  adduser $1 $3
  adduser $1 projetG
  adduser $1 projetI
  adduser $1 GroupG
  adduser $1 GroupI
fi
if [ $3 -eq "EquipeE" ]; then
  adduser $1 $3
  adduser $1 projetG
  adduser $1 projetH
  adduser $1 GroupG
  adduser $1 GroupH
fi
if [ $3 -eq "EquipeF" ]; then
  adduser $1 $3
  adduser $1 projetH
  adduser $1 projetI
  adduser $1 GroupH
  adduser $1 GroupI
fi
