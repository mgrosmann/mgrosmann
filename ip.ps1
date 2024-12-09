t connect



netsh winhttp set proxy "192.168.151.254:3128"
netsh winhttp set proxy "192.168.151.254:3128" bypass-list="192.168.*"
netsh winhttp import proxy source=ie
https://www.it-connect.fr/comment-utiliser-powershell-derriere-un-proxy/



Pas it connect

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Value "192.168.151.254:3128"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 1

https://www.techcrafters.com/portal/en/kb/articles/powershell-comprehensive-guide-to-configuring-proxy-settings-on-windows#Disabling_the_Proxy
