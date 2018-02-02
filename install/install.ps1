param(
[Parameter(Mandatory=$true)]
$KeyName,
[Parameter(Mandatory=$true)]
$DisplayName,
[Parameter(Mandatory=$true)]
$Version,
[Parameter(Mandatory=$true)]
$publisher,
[Parameter(Mandatory=$true)]
$icon
)

#Define Local Memory  
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT  

 
$AddRemKey = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"  
$ProductsKey = "HKCR:\Installer\Products\"  

$guid = [guid]::NewGuid().ToString("N")  
$guid.ToString()  
$guid = $guid.ToUpper()  

New-Item -Path $AddRemKey -Name $KeyName –Force  
New-ItemProperty -Path $AddRemKey"\"$KeyName -Name DisplayName -Value $DisplayName -PropertyType String  
New-ItemProperty -Path $AddRemKey"\"$KeyName -Name DisplayVersion -Value $Version -PropertyType String  
New-ItemProperty -Path $AddRemKey"\"$KeyName -Name UninstallString -Value "msiexec.exe /I$KeyName" -PropertyType String  
New-ItemProperty -Path $AddRemKey"\"$KeyName -Name Publisher -Value $publisher -PropertyType String  
New-ItemProperty -Path $AddRemKey"\"$KeyName -Name DisplayIcon -Value $icon -PropertyType String  
New-ItemProperty -Path $AddRemKey"\"$KeyName -Name Guid -Value $guid -PropertyType String  

New-Item -Path $ProductsKey -Name $guid –Force  
New-ItemProperty -Path $ProductsKey"\"$guid -Name ProductName -Value $DisplayName -PropertyType String -Force  

#Cleanup Local Memory  
remove-psdrive -name HKCR  
