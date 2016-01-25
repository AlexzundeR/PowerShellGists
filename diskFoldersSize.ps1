. 'D:\Job\powershell\get-FolderSize.ps1'


Get-ChildItem 'C:\Program Files (x86)' -Force | ? {$_.GetType() -eq [System.IO.DirectoryInfo]} | % {$_.FullName} | Get-FolderSize -Unit 'GB' | ? {$_.FolderSize -gt 1}