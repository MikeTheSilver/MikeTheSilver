<#
.Synopsis
   This scripts will list servers and will ask you for number of servers to which you want connect with SSH

.DESCRIPTION
   As described in the synopsis this script is used for storing and quick connecting to SSH servers, 
   I recommend to add this script to your windows profile, 
   so after opening new powershell window script will be invoked. To do that you need to add script to: 
   C:\Users\<username>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 
   also do not forget to check how structure of the csv should look

.Requirements
    Prepared csv file inside C:\Powershell\data.csv (or in any other destination just remember to change it inside script)

#>
function Get-content-from-file {
    $file = Import-Csv 'C:\Powershell\data.csv'
    $array = @()
    $number = 1
    foreach ($line in $file) {
        $array += @($line)
    }

    foreach ($item in $array) {
        $output = "$number  $($item.host)"
        Write-Host $output
        $number += 1
    }
    return $array
}

$array = Get-content-from-file

do{
    $selected = Read-Host("Select number of session")
    $arrlen = $array.Count
    if ([int]$selected -gt $arrlen -or [int]$selected -lt 1) {
        echo $arrlen
        echo $arrlen.gettype()
        echo $selected
        echo $selected.GetType()
        Write-Output "Provided number is out of range please select correct number... "
        $numberisok = $false
        Get-content-from-file
    }

    else {
        $file = Import-Csv 'C:\Powershell\data.csv'
        $array = @()
        $number = 1
        foreach ($line in $file) {
            $array += @($line)
        }
        $sessionip = $array.ip[$selected -1]
        $sessionuser = $array.user[$selected -1]
        $numberisok = $true
    }
}
while ($numberisok -eq $false)

try {
    ssh $sessionuser@$sessionip
}
catch {
    Write-Output "SSH connection failed something is wrong with connection params or with the server"
}