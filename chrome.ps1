$InstallerPath = "$env:TEMP\\chrome_installer.exe"
Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $InstallerPath
Start-Process -FilePath $InstallerPath -ArgumentList "/silent /install" -Wait
Remove-Item -Path $InstallerPath
