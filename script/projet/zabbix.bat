@echo off
Set "GLPI=\\192.168.1.10\Partage\GLPI-Agent-1.7.3-x64.msi"
msiexec /l*v log.txt /i zabbix_agent-4.0.6-x86.msi /qn^
        SERVER=192.168.6.76^
        TLSCONNECT=psk^
        TLSACCEPT=psk^
        TLSPSKIDENTITY=MyPSKID^
        TLSPSKVALUE=1f87b595725ac58dd977beef14b97461a7c1045b9a1c963065002c5473194952
pause
