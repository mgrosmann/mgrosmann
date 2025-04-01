@echo off
if exist "C:\Program Files\GLPI-AGENT\" (
    exit /b
    pause
)
set "GLPI=\\192.168.1.10\script$\GLPI-Agent-1.7.3-x64.msi"
msiexec /i "%GLPI%" /quiet SERVER="http://192.168.1.11/glpi" ADD_FIREWALL_EXCEPTION=1 
pause
