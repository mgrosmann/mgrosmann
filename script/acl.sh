#!/bin/bash
adduser denis
adduser evelyne
adduser fabrice
groupadd EquipeD
groupadd EquipeE
groupadd EquipeF
adduser denis EquipeD
adduser evelyne EquipeE
adduser fabrice EquipeF
mkdir /home/folderD
mkdir /home/folderE
mkdir /home/folderF
mkdir /home/DossierG
mkdir /home/DossierH
mkdir /home/DossierI
mkdir /home/ProjetG
mkdir /home/ProjetH
mkdir /home/ProjetI
chown :EquipeD folderD
chown :EquipeE folderE
chown :EquipeF folderF
chmod 770 folderD
chmod 770 folderE
chmod 770 folderF
groupadd projetG
groupadd projetH
groupadd projetI
adduser denis projetG
adduser denis projetI
adduser evelyne projetH
adduser evelyne projetG
adduser fabrice projetH
adduser fabrice projetI
cd /home/folderD
ln -s /home/ProjetG ProjetG
ln -s /home/ProjetI ProjetI
cd /home/folderE
ln -s /home/ProjetG ProjetG
ln -s /home/ProjetH ProjetH
cd /home/folderF
ln -s /home/ProjetH ProjetH
ln -s /home/ProjetI ProjetI
groupadd GroupG
groupadd GroupH
groupadd GroupI
adduser denis GroupG
adduser denis GroupI
adduser evelyne GroupG
adduser evelyne GroupH
adduser fabrice GroupH
adduser fabrice GroupI
cd ..
chown :GroupG ProjetG
chown :GroupH ProjetH
chown :GroupI ProjetI
chmod 770 ProjetG
chmod 770 ProjetH
chmod 770 ProjetI
cd /home/ProjetG
ln -s /home/DossierG DossierG
cd /home/ProjetH
ln -s /home/DossierH DossierH
cd /home/ProjetI
ln -s /home/DossierI DossierI
cd ..