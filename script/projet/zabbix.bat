@ECHO OFF
if exist "C:\Program Files\Zabbix Agent" (
    echo Zabbix Agent est déjà installé. Fin du script.
    exit /b
)
set "zabbix=\\192.168.1.10\script$\zabbix_agent-7.2.5-windows-amd64-openssl.msi"
set "server=http://192.168.1.11"
set "hostname=zabbix-agent"
msiexec /i "%zabbix%" /qn SERVER=%server% SERVERACTIVE=%server% HOSTNAME=%hostname%
pause
