Import-Module -Name ActiveDirectory

Function Find-CGNewServers
{

[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,ValueFromPipeLine=$True)][Microsoft.ActiveDirectory.Management.ADComputer[]]$Servers

    )

BEGIN
{
    $ServerList,
    $NewServers = @()
    
    
    $ServerList = (Get-Content -Path "\\NC-FileShare\Departments\IT\Powershell\WindowsUpdate\UpdateNight\RL-Servers.txt") + `
                     (Get-Content -Path "\\NC-FileShare\Departments\IT\Powershell\WindowsUpdate\UpdateNight\MV-Servers.txt") + `
                     (Get-Content -Path "\\NC-FileShare\Departments\IT\Powershell\WindowsUpdate\UpdateNight\RM-Servers.txt") + `
                     (Get-Content -Path "\\NC-FileShare\Departments\IT\Powershell\WindowsUpdate\UpdateNight\Manual-Servers.txt")
}


PROCESS
{
    ForEach($Server in $Servers)
    {
        If(!$ServerList.Contains($Server.DnsHostName))
        {
            $NewServers += ,$Server.DnsHostName
        }

    }

}

END
{
    $NewServers | Out-File -FilePath "\\NC-fileshare\Departments\IT\PowerShell\WindowsUpdate\UpdateNight\New-Servers.txt"
    Return $NewServers
}

}

Function Get-CGServerList
{

[cmdletbinding()]
param(
        
        [switch]$NewList = $false,
        [switch]$ManualList = $false,
        [switch]$Raleigh = $false,
        [switch]$Morrisville = $false,
        [switch]$Richmond = $false,
        $Servers
)

BEGIN
{}

PROCESS
{
    
   
    if($NewList)
    {
        $Servers += (Get-Content -Path "\\NC-FileShare\Departments\IT\Powershell\WindowsUpdate\UpdateNight\New-Servers.txt")
    }
    if($ManualList)
    {
        $Servers += (Get-Content -Path "\\NC-FileShare\Departments\IT\Powershell\WindowsUpdate\UpdateNight\Manual-Servers.txt")
    }
    if($Raleigh)
    {
        $Servers += (Get-Content -Path "\\NC-FileShare\Departments\IT\Powershell\WindowsUpdate\UpdateNight\RL-Servers.txt")
    }
    if($Morrisville)
    {
        $Servers += (Get-Content -Path "\\NC-FileShare\Departments\IT\Powershell\WindowsUpdate\UpdateNight\MV-Servers.txt")
    }
    if($Richmond)
    {
        $Servers += (Get-Content -Path "\\NC-FileShare\Departments\IT\Powershell\WindowsUpdate\UpdateNight\RM-Servers.txt")
    }




}

END
{
    Return $Servers
}

}

Function Test-CGUpdateTask
{
[cmdletbinding()]
param(

    [Parameter(Mandatory=$True,ValueFromPipeLine=$True)][string[]]$Servers,
    [bool]$Found,
    $ServerTable = @{}
)

BEGIN
{}

PROCESS
{
    foreach($Server in $Servers)
    {
        Try
        {
            Invoke-Command -ComputerName $Server -ScriptBlock { Get-ScheduledTask -TaskPath "\PowerShell Stuff\" -TaskName "Install-WinUpdates" } -ErrorAction Stop | Out-Null
            $Found = $True
            $ServerTable.add($Server, $Found)

        }
        Catch
        {
            $Found = $false
            $ServerTable.add($Server, $Found)
        }

       
    }
}

END
{
    Return $ServerTable
}

}

Function Push-CGUpdateTask
{
[cmdletbinding()]
param(

    [Parameter(Mandatory=$True,ValueFromPipeline=$True)]$ServerTable,
    $return = @{}
    
)

BEGIN
{}

PROCESS
{
    foreach($ServerName in $ServerTable.keys)
    {
        if(!$servertable[$Servername])
        {
            try
            {
                Invoke-Command -ComputerName $ServerName -FilePath \\nc-fileshare\Departments\IT\PowerShell\WindowsUpdate\UpdateNight\Create-InstallWinUpdatesTask.ps1 | Out-Null
                $Return.add($ServerName, $True)

            }
            catch
            {

            }
        }
    }

}

END
{
    return $return
}





}

Function Install-CGUpdates
{
[cmdletbinding()]
param(

    [Parameter(Mandatory=$True,ValueFromPipeline=$True)]$ServerNames,
    [double]$Seconds = 90.0
)

BEGIN
{}

PROCESS
{

    Foreach($Name in $ServerNames)
    {
        Write-Warning "Installing Updates on $Name and waiting $Seconds seconds..."
    
        Invoke-Command -ComputerName $Name -ScriptBlock { Start-ScheduledTask -TaskPath "\PowerShell Stuff\" -TaskName "Install-WinUpdates" }
    
        Start-Sleep -Seconds $Seconds

    }

}

END
{
    Return $ServerNames

}


}

Function Restart-CGServers
{
[cmdletbinding()]
param(

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0)][string]$ServerNames,
    [double]$Seconds = 90.0
)

BEGIN
{
    Write-Warning "This Will begin the reboot process of all Servers starting in 20 Seconds. Press CTRL-C to abort"

    For ($i = 0; $i -le 100; $i+=5 )
    {
    Write-Progress -Activity "Pause in Progress" -Status "$i% Complete:" -PercentComplete $i;
    start-sleep -Seconds 1.0
    }
  
}

PROCESS
{
    
    Foreach($Name in $ServerNames)
    {
        Write-Warning "Restarting $Name and waiting $Seconds Seconds..."
        
        Try
        {
            Restart-Computer -ComputerName $Name -Force -ErrorAction Stop
            Start-Sleep -Seconds $Seconds
        }
        Catch
        {
            Write-Warning "Could Not Restart $Name"
        }
    }
    
}

END
{}

}

Function Restart-CGWorkstations
{
[cmdletbinding()]
param(

    [Parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0)][Microsoft.ActiveDirectory.Management.ADComputer[]]$WorkStations,
    [double]$Seconds = 2.0
)

BEGIN
{
    Write-Warning "This Will begin the reboot process of all Workstations starting in 20 Seconds. Press CTRL-C to abort"

    For ($i = 0; $i -le 100; $i+=5 )
    {
    Write-Progress -Activity "Pause in Progress" -Status "$i% Complete:" -PercentComplete $i;
    start-sleep -Seconds 1.0
    }

  
}

PROCESS
{
   
    Foreach($Station in $WorkStations)
    {
        
        Try
        {
            #Restart-Computer -ComputerName $($Station.Name) -Force -ErrorAction Stop
            Invoke-Command $($Station.Name) -scriptblock { Restart-Computer -Force }
            Write-Output "Restarting $($Station.Name) and waiting $Seconds Seconds..."
            Start-Sleep -Seconds $Seconds
        }
        Catch
        {
            Write-Warning "Could Not Restart $($Station.Name)"
        }
    }    
}

END
{}

}

Function Install-CGDrivers
{
[cmdletbinding()]
param(
    
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0)][Microsoft.ActiveDirectory.Management.ADComputer[]]$WorkStations

    )

BEGIN
{

}
PROCESS
{
    <#
    $OnlineStations
    
    foreach($Station in $WorkStations)
    {   
       
        
        if(Test-NetConnection -Port 5985 -ComputerName $Station.DNSHostName -info)
        {
            $OnlineStations += $Station.DNSHostname
        }
       
    
    }
    #>
    
   
    Invoke-Command -ComputerName $($WorkStations.DNSHostName) -ScriptBlock { & "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" /ApplyUpdates -silent }  -InDisconnectedSession -ErrorVariable Failed -ErrorAction SilentlyContinue
   


    Write-Output $Failed.message | Out-File -FilePath "\\circlegraphicsonline.com\Raleigh\Departments\IT\PowerShell\Logs\Install-CGDrivers.log" -Append
}

END
{

}
}

