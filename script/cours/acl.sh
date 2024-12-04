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
mkdir /home/dossierD
mkdir /home/dossierE
mkdir /home/dossierF
mkdir /home/dossierG
mkdir /home/dossierH
mkdir /home/dossierI
mkdir /home/folderG
mkdir /home/folderH
mkdir /home/folderI
chown :EquipeD dossierD
chown :EquipeE dossierE
chown :EquipeF dossierF
chmod 770 dossierD
chmod 770 dossierE
chmod 770 dossierF
groupadd projetG
groupadd projetH
groupadd projetI
adduser denis projetG
adduser denis projetI
adduser evelyne projetH
adduser evelyne projetG
adduser fabrice projetH
adduser fabrice projetI
cd /home/dossierD
ln -s /home/folderG folderG
ln -s /home/folderI folderI
cd /home/dossierE
ln -s /home/folderG folderG
ln -s /home/folderH folderH
cd /home/dossierF
ln -s /home/folderH folderH
ln -s /home/folderI folderI
groupadd groupG
groupadd groupH
groupadd groupI
adduser denis groupG
adduser denis groupI
adduser evelyne groupG
adduser evelyne groupH
adduser fabrice groupH
adduser fabrice groupI
cd ..
chown :groupG folderG
chown :groupH folderH
chown :groupI folderI
chmod 770 folderG
chmod 770 folderH
chmod 770 folderI
cd /home/folderG
ln -s /home/dossierG dossierG
cd /home/folderH
ln -s /home/dossierH dossierH
cd /home/folderI
ln -s /home/dossierI dossierI
cd ..
