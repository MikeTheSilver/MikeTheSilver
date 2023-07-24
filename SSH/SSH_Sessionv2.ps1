<#
.Synopsis
   This scripts first will list files which contain ssh connections and will ask you to select file then list servers and will ask you for number of servers to which you want connect with SSH

.DESCRIPTION
   As described in the synopsis this script is used for storing and quick connecting to SSH servers, 
   I recommend to add this script to your windows profile, 
   so after opening new powershell window script will be invoked. To do that you need to add script to: 
   C:\Users\<username>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 
   also do not forget to check how structure of the csv should look

.Requirements
    Prepared csv files inside C:\Powershell\csv\ (or in any other destination just remember to change it in script)

#>
function List-file {
    param (
    [String]$name
    )
    $path = "C:\Powershell\csv\" + $name
    $file = Import-Csv $path
    $array = @()
    $number = 1
    foreach ($line in $file) {
        $array += @($line)
    }
    Write-Host "0  Go back to files"
    foreach ($item in $array) {
        $output = "$number  $($item.host)"
        Write-Host $output
        $number += 1
    }
    return $array
}
function List-csvfiles {
    $files = Get-ChildItem C:\Powershell\csv\
    $array = @()
    $number = 1
    foreach ($file in $files) {
        $array += @($file)
    }

    foreach ($item in $array) {
        $output = "$number  $($item.Name)"
        Write-Host $output
        $number += 1
    }
    return $array
}
function Get-filename {
    param (
    [int]$number
    )
    $files = Get-ChildItem C:\Powershell\csv\
    $files[$number - 1].Name
}

$array_dir = List-csvfiles

do {
    [int]$selected_file = Read-Host("Select number of catalog")
    $dirarrlen = $array_dir.Count
    if ($selected_file -gt $dirarrlen -or $selected_file -lt 1) {
        Write-Output "Provided number is out of range please select correct number... "
        $file_is_ok = $false
    }

    else {
        Write-Host "`n"
        $file_name = Get-filename $selected_file
        $file_ouput = List-file $file_name
        do {
            $selected_server = Read-Host("Select number of ssh connection")
            $filearrlen = $file_ouput.Count
            if ([int]$selected_server -gt $filearrlen -or [int]$selected_server -lt 0) {
                Write-Output "Provided number is out of range please select correct number... "
                $server_is_ok = $false
                $file_is_ok = $false
            }
            elseif ([int]$selected_server -eq 0) {
                $server_is_ok = $true
                $file_is_ok = $false
            }
            else {
                $sessionip = $file_ouput.ip[$selected_server -1]
                $sessionuser = $file_ouput.user[$selected_server -1]
                $server_is_ok = $true
                $file_is_ok = $true
            }
        }
        while($server_is_ok -eq $false)
        
        $number = 1
        Write-Host "`n"
        foreach ($file in $array_dir) {
            $output = "$number  $($file.Name)"
            Write-Host $output
            $number += 1
        }
    }
}
while ($file_is_ok -eq $false)

# Connect
try {
    ssh $sessionuser@$sessionip
}
catch {
    Write-Output "SSH connection failed something is wrong with connection params or with the server"
}