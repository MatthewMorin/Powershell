Function Get-RLServers
{
    [CmdletBinding()]
    Param(
        [string]$OUName = "Servers"
        )

BEGIN{}

PROCESS
{
    $SB = "OU=Servers,OU=Raleigh,OU=Circle Graphics,DC=CircleGraphicsOnline,DC=com"
    $OU = Get-ADOrganizationalUnit -SearchBase $SB -Filter { Name -like $OUName }
    $SB = $OU | Select-Object -ExpandProperty DistinguishedName

    $Servers = Get-ADComputer -SearchBase "OU=Servers,OU=Raleigh,OU=Circle Graphics,DC=CircleGraphicsOnline,DC=com" -Filter { Enabled -eq $True }

    Return $Servers
}

END{}

}

Function Get-RMServers
{
    [CmdletBinding()]
    Param(
        [string]$OUName = "Servers"
        )

BEGIN{}

PROCESS
{
    #$SB = "OU=Servers,OU=Richmond,OU=Circle Graphics,DC=CircleGraphicsOnline,DC=com"
    #$OU = Get-ADOrganizationalUnit -SearchBase $SB -Filter { Name -like $OUName }
    #$SB = $OU | Select-Object -ExpandProperty DistinguishedName

    $Servers = Get-ADComputer -SearchBase "OU=Servers,OU=Richmond,OU=Circle Graphics,DC=CircleGraphicsOnline,DC=com" -Filter { Enabled -eq $True }

    Return $Servers
}

END{}

}


Function Get-MVServers
{
    [CmdletBinding()]
    Param(
        [string]$OUName = "Servers"
        )

BEGIN{}

PROCESS
{
    #$SB = "OU=Servers,OU=Richmond,OU=Circle Graphics,DC=CircleGraphicsOnline,DC=com"
    #$OU = Get-ADOrganizationalUnit -SearchBase $SB -Filter { Name -like $OUName }
    #$SB = $OU | Select-Object -ExpandProperty DistinguishedName

    $Servers = Get-ADComputer -SearchBase "OU=Servers,OU=Morrisville,OU=Circle Graphics,DC=CircleGraphicsOnline,DC=com" -Filter { Enabled -eq $True }

    Return $Servers
}

END{}

}


Function Get-RLWorkstations
{
    [CmdletBinding()]
    Param(
        [string]$OUName = "Workstations",
        [int]$test
    )

BEGIN{}

PROCESS
{
    $SB = "OU=Workstations,OU=Raleigh,OU=Circle Graphics,DC=CircleGraphicsOnline,DC=com"
    #$OU = Get-ADOrganizationalUnit -SearchBase $SB -Filter { Name -like $OUName }
    #$SB = $OU | Select-Object -ExpandProperty DistinguishedName

    $Workstations = Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True -and Name -notlike "*IT*" }

    Return $Workstations
}

END{}

}

Function Get-RMWorkstations
{
    [CmdletBinding()]
    Param(
        [string]$OUName = "Computers",
        [int]$test
    )

BEGIN{}

PROCESS
{
    $SB = "OU=Computers,OU=Richmond,OU=Circle Graphics,DC=CircleGraphicsOnline,DC=com"
    #$OU = Get-ADOrganizationalUnit -SearchBase $SB -Filter { Name -like $OUName }
    #$SB = $OU | Select-Object -ExpandProperty DistinguishedName

    $Workstations = Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True }

    Return $Workstations
}

END{}

}


Function Get-MVWorkstations
{
    [CmdletBinding()]
    Param(
        
    )

BEGIN{}

PROCESS
{
    $SB = "OU=Workstations,OU=Morrisville,OU=Circle Graphics,DC=CircleGraphicsOnline,DC=com"
    #$OU = Get-ADOrganizationalUnit -SearchBase $SB -Filter { Name -like $OUName }
    #$SB = $OU | Select-Object -ExpandProperty DistinguishedName

    $Workstations = Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True }

    Return $Workstations
}

END{}

}


Function Get-NCUsers
{


}

Function Get-CGWorkstations
{
    [CmdletBinding()]
    Param(
       [switch]$Morrisville = $false,
       [switch]$Raleigh = $false,
       [switch]$Richmond = $false
       )

BEGIN
{  
   
}

PROCESS
{

    if($Raleigh)
    {
        $SB = "OU=Computers,"
        $OU = Get-ADOrganizationalUnit -Filter { Name -like "Raleigh"}
        $SB += ($OU | Select-Object -ExpandProperty DistinguishedName)
        $Workstations += Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True -and Name -notlike "*ITWB*" }
    }

    if($Richmond)
    {
        $SB = "OU=Computers,"
        $OU = Get-ADOrganizationalUnit -Filter { Name -like "Richmond" }
        $SB += ($OU | Select-Object -ExpandProperty DistinguishedName)
        $Workstations += Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True }
    }
    if ($Morrisville)
    {
        $SB = "OU=Computers,"
        $OU = Get-ADOrganizationalUnit -Filter { Name -like "Morrisville" }
        $SB += ($OU | Select-Object -ExpandProperty DistinguishedName)
        $Workstations += Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True }
    }
}  
  
END   
{
    Return $Workstations
}

}

Function Get-CGServers
{
    [CmdletBinding()]
    Param(
       [switch]$Morrisville = $false,
       [switch]$Raleigh = $false,
       [switch]$Richmond = $false
       )

BEGIN
{  

}

PROCESS
{

    if ($Morrisville)
    {
        $SB = "OU=Servers,"
        $OU = Get-ADOrganizationalUnit -Filter { Name -like "Morrisville" }
        $SB += ($OU | Select-Object -ExpandProperty DistinguishedName)
        $Servers += Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True  }
    }

    if($Raleigh)
    {
        $SB = "OU=Servers,"
        $OU = Get-ADOrganizationalUnit -Filter { Name -like "Raleigh" }
        $SB += ($OU | Select-Object -ExpandProperty DistinguishedName)
        $Servers += Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True  }
    }

    if($Richmond)
    {
        $SB = "OU=Servers,"
        $OU = Get-ADOrganizationalUnit -Filter { Name -like "Richmond" }
        $SB += ($OU | Select-Object -ExpandProperty DistinguishedName)
        $Servers += Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True  }
    }
    
}  
  
END   
{
    Return $Servers

}

}