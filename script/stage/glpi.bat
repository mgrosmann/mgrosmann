@echo off
Set "GLPI=\\192.168.1.10\Partage\GLPI-Agent-1.7.3-x64.msi"
Msiexec /i "%GLPI%" /quiet SERVER=http://192.168.1.11/glpi ADD_FIREWALL_EXCEPTION=1
pause
