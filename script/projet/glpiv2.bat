msiexec /i “\\192.168.1.10\script$\glpi.msi“ /quiet RUNNOW=1 SERVER=http://192.168.1.11/glpi/front/inventory.php
curl http://localhost:62354/now
