Set-ExecutionPolicy Unrestricted
$wc=new-object net.webclient; $wp=[system.net.WebProxy]::GetDefaultProxy(); $wp.UseDefaultCredentials=$true; $wc.Proxy=$wp; iex ($wc.DownloadString('https://chocolatey.org/install.ps1'))
choco upgrade firefox -y
choco upgrade chrome -y
choco upgrade python -y
choco upgrade vcredist-all -y
choco upgrade vcredist2015 -y