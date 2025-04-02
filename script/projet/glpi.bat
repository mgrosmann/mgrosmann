@echo off
if exist "C:\Program Files\GLPI-Agent\" (
  exit
)
set glpi="\\192.168.1.10\script$\GLPI-Agent-1.7.3-x64.msi"
set server="http://192.168.1.11/glpi"
msiexec /i %glpi%  /quiet SERVER=%server% ADD_FIREWALL_EXCEPTION=1
