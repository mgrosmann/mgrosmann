@ECHO OFF
Set "zabbix=\\192.168.1.10\Partage\GLPI-Agent-1.7.3-x64.msi"
set /p server=IP du Zabbix Server: 
set /p hostname=Hostname du Zabbix Agent: 
REM regle pare feu
netsh advfirewall firewall add rule name="Zabbix Agent" dir=in action=allow protocol=TCP localport=10050
msiexec /l*v %TEMP%\install-zabbix-agent-log.txt /i %zabbix%^
 SERVER=%server%^
 SERVERACTIVE=%server%^
 HOSTNAME=%hostname%^
 TIMEOUT=15^
 /qn
