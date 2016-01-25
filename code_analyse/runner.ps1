$currentPath = (Split-Path $MyInvocation.MyCommand.Path -Parent) + '\\'

. ($currentPath+'CodeAnalyse.ps1')
. ($currentPath+'Get-Project-Reference.ps1')


#Get-Project-References 'C:\FastJob\berth.starter\sources\Berth.Starter\berth.starter.csproj'


Analyse-Code-Folder 'C:\FastJob\berth' -ignoreFilePath 'C:\FastJob\berth.starter\ignore.config'

