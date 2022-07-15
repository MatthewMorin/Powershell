Function Get-Workstations
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

    if ($Morrsiville)
    {
        $SB = "OU=Workstations,"
        $OU = Get-ADOrganizationalUnit -Filter { Name -like "Morrisville" }
        $SB += ($OU | Select-Object -ExpandProperty DistinguishedName)
        $Workstations += Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True -and Name -notlike "*IT*" }
    }

    if($Raleigh)
    {
        $SB = "OU=Workstations,"
        $OU = Get-ADOrganizationalUnit -Filter { Name -like "Raleigh" }
        $SB += ($OU | Select-Object -ExpandProperty DistinguishedName)
        $Workstations += Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True -and Name -notlike "*IT*" }
    }

    if($Richmond)
    {
        $SB = "OU=Computers,"
        $OU = Get-ADOrganizationalUnit -Filter { Name -like "Richmond" }
        $SB += ($OU | Select-Object -ExpandProperty DistinguishedName)
        $Workstations += Get-AdComputer -SearchBase $SB -Filter { Enabled -eq $True -and Name -notlike "*IT*" }
    }
    
}  
  
END   
{
    Return $Workstations
}

}




