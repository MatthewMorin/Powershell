$WorkStations = Get-CGWorkstations -Richmond

 Invoke-Command -ComputerName $($WorkStations.DNSHostName) -ScriptBlock { & "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" /ApplyUpdates -silent }  -InDisconnectedSession -ErrorVariable Failed -ErrorAction SilentlyContinue
   


    Write-Output $Failed.message | Out-File -FilePath "\\circlegraphicsonline.com\Raleigh\Departments\IT\PowerShell\Logs\Install-CGDrivers.log" -Append