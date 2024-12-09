$InterfaceAlias = "Ethernet" 
$IPAddress = "192.168.1.122" 
$SubnetMask = "255.255.255.0"
$DefaultGateway = "192.168.1.1" 
$DNSServer = "192.168.1.1"  
Set-NetAdapterBinding -Name $InterfaceAlias -ComponentID ms_tcpip6 -Enabled $false
Write-Host "Configuration de l'adresse IP..."
New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -PrefixLength $PrefixLength -DefaultGateway $DefaultGateway -Confirm:$false
Write-Host "Configuration du serveur DNS..."
Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $DNSServer



netsh winhttp set proxy "192.168.151.254:3128"
netsh winhttp set proxy "192.168.151.254:3128" bypass-list="192.168.*"
netsh winhttp import proxy source=ie
