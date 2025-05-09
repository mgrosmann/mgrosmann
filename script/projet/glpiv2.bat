@echo off
if exist "C:\Program Files\GLPI-Agent\" (
  exit
)
path = \\192.168.1.10\script$\glpi.msi
msiexec /i %path% /quiet RUNNOW=1 SERVER=http://192.168.1.11/glpi/front/inventory.php
curl http://localhost:62354/now
