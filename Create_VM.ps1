<#
.Synopsis
   This scripts creates vm in you hyperv manager

.DESCRIPTION
   It creates vm, assign disc to it, declare RAM memory of machine, also allows you to add network adapter to the machine 

.Requirements
    You need to enable Hyper-V feature on your machine, for Windows 10 you can use command below:
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
#>
param(
    [Parameter(Position=0,mandatory=$true)]
    [string] $MachineName,
    [Parameter(Position=1,mandatory=$true)]
    [string] $MachinePath,
    [Parameter(Position=2,mandatory=$true)]
    [string] $DiscName,
    [Parameter(Position=3,mandatory=$true)]
    [string] $DiscPath
)

#Declare RAM memory
[int64] $RAMMemory = 4096MB

#Create VM
$VM = New-VM -Name $MachineName -MemoryStartupBytes $RAMMemory -Path "$MachinePath"

#Declare disc memory and create full path to disc
[int64] $DiscMemory = 50GB
if($DiscPath[-1] -ne '\'){$DiscPath = $DiscPath + '\'}
$Disc = $DiscPath + $DiscName + ".vhdx"

#Create Disc
New-VHD -Path $Disc -SizeBytes $DiscMemory -Dynamic

#Connect VM with Disc
Add-VMHardDiskDrive -VMName $MachineName -Path $Disc 


#Add network adapter
$title    = 'Select yes or no to continue'
$question = 'Do you want to add network adapter to the vm?'
$choices  = '&Yes', '&No'
$decision = $Host.UI.PromptForChoice($title,$question, $choices, 1)
if ($decision -eq 0) {
    Get-VMNetworkAdapter -All | Where-Object SwitchName -ne $null | Format-Table
    $NetworkAdapter = Read-Host -Prompt "Enter adapter name: "
    Connect-VMNetworkAdapter -VMName $MachineName -SwitchName $NetworkAdapter
} 

#Start
Start-VM -Name $MachineName
Start-Sleep -Seconds 20
Get-VM -Name $machinename
 