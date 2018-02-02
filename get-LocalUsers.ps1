#([ADSI]("WinNT://"+[System.Environment]::MachineName)).Children
#$users = (([ADSI]("WinNT://"+[System.Environment]::MachineName)).Children|?{$_.SchemaClassName -eq "user"}) | select -First 10

#(New-Object System.Security.Principal.SecurityIdentifier($users[0].objectSid.value,0)).Value
#$users[0].Groups()
#$users | %{ $_.Groups()| Foreach-Object {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}}

Add-Type -AssemblyName  System.DirectoryServices.AccountManagement

#$ContextType = [System.DirectoryServices.AccountManagement.ContextType]::Machine
#$group = [System.DirectoryServices.AccountManagement.GroupPrincipal]::FindByIdentity($ContextType ,"Пользователи")
#$group.GetMembers()

$env:COMPUTERNAME

$type = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext('Machine', $env:COMPUTERNAME)

$UserPrincipal = New-Object System.DirectoryServices.AccountManagement.UserPrincipal($type)

# adjust your search criteria here:
$UserPrincipal.PasswordNeverExpires = $true
$UserPrincipal.Enabled = $true

$searcher = New-Object System.DirectoryServices.AccountManagement.PrincipalSearcher
$searcher.QueryFilter = $UserPrincipal
$results = $searcher.FindAll();

$results | Select-Object -Property Name, LastLogon, Enabled, PasswordNeverExpires 