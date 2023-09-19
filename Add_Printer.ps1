<#
.Synopsis
   This scripts adds printer form your print server

.DESCRIPTION
   It will connect with your print server, download driver and information about printer from there and will also add this printer

.Requirements
    Installed printer server funciton on your Windows Server, also you need to have setup printer there and add driver to it
#>
Add-Type -AssemblyName PresentationCore,PresentationFramework

Set-Variable -Name "pc" "$env:computername"
Set-Variable -Name "printer" "printer-name"

[System.Windows.MessageBox]::Show("Click OK to connect with printer:)","Please Wait","OK") | out-null
# Line below will find and install printer from the server, remember to set there correct printer name
rundll32 printui.dll,PrintUIEntry /ga /in /c\\'Get-Variable -Name "pc"' /n\\print-server\printer-name             


Start-Sleep -s 20
#remember to set there correct printer name
Get-Printer -Name "\\print-server\printer-name" | out-null

if($error[0])
{
    [System.Windows.MessageBox]::Show("There except an error while adding printer","Error","OK") | out-null
}
else
{
    [System.Windows.MessageBox]::Show("You succesfully added printer $printer","Congratulations","OK") | out-null
}
