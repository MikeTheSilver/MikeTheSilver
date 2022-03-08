Add-Type -AssemblyName PresentationCore,PresentationFramework

Set-Variable -Name "pc" "$env:computername"
Set-Variable -Name "printer" "printer-name"

[System.Windows.MessageBox]::Show("Click OK to connect with printer:)","Please Wait","OK") | out-null

rundll32 printui.dll,PrintUIEntry /ga /in /c\\'Get-Variable -Name "pc"' /n\\print-server\printer-name              #Here u can't use variable u have to enter full printer name

Start-Sleep -s 20
Get-Printer -Name "\\print-server\printer-name" | out-null

if($error[0])
{
    [System.Windows.MessageBox]::Show("There except an error while adding printer please contact with IT Helpdesk","Error","OK") | out-null
}
else
{
    [System.Windows.MessageBox]::Show("You succesfully added printer $printer","Congratulations","OK") | out-null
}
