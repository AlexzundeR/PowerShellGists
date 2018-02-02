param(
[Parameter(Mandatory=$true)]
$KeyName
)

#Define Local Memory  
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT  

 
$AddRemKey = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"  
$ProductsKey = "HKCR:\Installer\Products\"  

$guid = Get-ItemProperty -Path $AddRemKey"\"$KeyName -Name Guid

$guid = $guid.Guid

"удаляем 1"
Remove-Item -Path $AddRemKey"\"$KeyName –Force  
"удаляем 2"
Remove-Item -Path $ProductsKey"\"$guid –Force  
"все"

#Cleanup Local Memory  
remove-psdrive -name HKCR  
