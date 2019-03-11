<#
Purpose - To edit the registry key value in bulk VMs
Developer - Janarthanan
Date - 5/3/2019

References -
https://gallery.technet.microsoft.com/scriptcenter/How-to-switch-UAC-level-0ac3ea11
https://devblogs.microsoft.com/scripting/weekend-scripter-use-powershell-to-easily-modify-registry-property-values/

#>
$cred=Get-Credential

$file=Read-Host "Input VM file name [C:\VM.txt]"

$list=Get-content $file

foreach ($vm in $list)
{
"

----$vm-----
"

try{
#Changing 1st Key
Invoke-command -computername $vm -scriptblock { Set-Location "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\UIPI";
Set-ItemProperty -Path . -Name "(Default)" -Value "0x00000001(1)" } -Credential $cred -ErrorAction Stop

#Changing other Keys
Invoke-command -computername $vm -scriptblock { Set-Location "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System";
Set-ItemProperty -Path . -Name "ConsentPromptBehaviorAdmin" -Value "5";
Set-ItemProperty -Path . -Name "PromptOnSecureDesktop" -Value "1";
Set-ItemProperty -Path . -Name "EnableLUA" -Value "1";} -Credential $cred -ErrorAction Stop

Write-Host "<<Info>> Successfully configured $vm" -foreground Green

#Rebooting the server once success
try{
Restart-Computer -ComputerName $vm -Credential $cred -confirm:$false -ErrorAction Stop
Write-Host "<<Info>> Successfully rebooted $vm" -foreground Green
}
catch{
Write-Host "<<Error>> Problem in rebooting $vm" -foreground Red
}
}
catch{
Write-Host "<<Error>> Something went wrong during the configuration in $vm" -foreground Red
}
}

"

Everything Done
"