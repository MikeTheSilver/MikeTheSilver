function PC_Hardware()
{
    Get-ComputerInfo | Select  BiosManufacturer, CsDNSHostName, OsTotalVisibleMemorySize, CsProcessors, OsVersion | Format-List
}

function Network_Properties()
{
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE |  Select-Object -Property [a-z]* | Select Description, IPAddress, IPSubnet, DefaultGateway, DHCPServer, DNSServerSearchOrder | fl
}

function Software_Installed()
{
    #Get-WmiObject -Class Win32_Product | Select-Object Vendor -Unique
    #Write-Host "Write the name of the Vendor"
    #$ven = Read-Host
    #Get-WmiObject -Class Win32_Product | Where Vendor -EQ $ven | Select Name, Version
    Get-WmiObject -Class Win32_Product | Select Vendor, Name, Version | fl
}

function Components_Usage()
{
    Get-CIMInstance Win32_OperatingSystem | Select @{Name='Avaiable RAM in MB';Expression={$PSItem.FreePhysicalMemory}}
    Get-Volume | Select DriveLetter, FileSystemType, @{Name='Size in MB';Expression={$PSItem.Size}},@{Name='Size remaining in MB';Expression={$PSItem.SizeRemaining}} | Fl
    Get-WmiObject -Class Win32_Processor | Select @{Name='CPU usage in %';Expression={$PsItem.LoadPercentage}}
}

function Installed_Printers()
{
    Get-Printer | select Name, DriverName | fl
}


$list = "1 - Check PC properties","2 - Check network properties","3 - Check installed apps","4 - Check components usage","5 - Check installed printers"

do
{
    Write-Host "`n"
    Write-Host "Hi, what do you need?"
    Write-Host "`n"
    $list
    Write-Host "`n"

    # Check if user printed numeric value
    try
    {
        [int] $Num = Read-Host -Prompt "Choose what I have to show by selecting number"
        Write-Host "`n"
    }
    catch
    {
        Write-Host "Error! You have to input int value"
    }

    # Check if value is in scope
    if($Num -lt 6 -and $Num -gt 0)
    {
        Write-Host "You have selected number", $Num  
    }
    else
    {
        Write-Host "Error! Number is not in our scope"
        exit
    }

    # Use function assigned to number
    if($Num -eq 1)
    {
        PC_Hardware
    }

    elseif($Num -eq 2)
    {
        Network_Properties
    }

    elseif($Num -eq 3)
    {
        $title    = 'Confirm'
        $question = 'Save output to file?'
        $choices  = '&Yes', '&No'
        $decision = $Host.UI.PromptForChoice($title, $question, $choices,1)
        if($decision -eq 0)
        {
            $path = Read-Host -prompt "Please write path"
            try
            {
                Software_Installed | Out-File -FilePath "C:\ps\test"
            }
            catch
            {
                Write-Host "Error! The path which you provided is wrong"
            }
        }
        else
        {
            Software_Installed
        }
    }

    elseif($Num -eq 4)
    {
        Components_Usage
    }

    elseif($Num -eq 5)
    {
        Installed_Printers
    }

    $t    = 'Confirm'
    $q = 'Do you need something else?'
    $c  = '&Yes', '&No'
    $d = $Host.UI.PromptForChoice($t, $q, $c,1)
}
while($d -eq 0)

