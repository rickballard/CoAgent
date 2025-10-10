# Neutralizes AppKey 18 (Calculator) for current user
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AppKey\18" -Force | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AppKey\18" -Name "Association" -Value "" -PropertyType String -Force | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AppKey\18" -Name "ShellExecute" -Value "" -PropertyType String -Force | Out-Null
Write-Host "AppKey 18 (Calculator) disabled. Restart Explorer to apply."
