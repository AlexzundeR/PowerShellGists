$currentPath = (Split-Path $MyInvocation.MyCommand.Path -Parent) + '\\'

. ($currentPath+'CodeAnalyse.ps1')
. ($currentPath+'Get-Project-Reference.ps1')


#Get-Project-References 'C:\FastJob\berth.starter\sources\Berth.Starter\berth.starter.csproj'
$Host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size (500, 25)

Analyse-Code-Folder 'D:\Job\berth' -ignoreFilePath 'D:\Job\berth\ignore.config' *> ($currentPath+'ПК-О.log')

Analyse-Code-Folder 'D:\Job\berth.starter' -ignoreFilePath 'D:\Job\berth\ignore.config' *> ($currentPath+'ПК-СД.log')

Analyse-Code-Folder 'D:\Job\berth.importModule' -ignoreFilePath 'D:\Job\berth\ignore.config' *> ($currentPath+'ПК-ВВ.log')

"Завершено"
