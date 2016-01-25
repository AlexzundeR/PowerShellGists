function Analyse-Code-Folder(){
[CmdletBinding()]
Param
    (
        # Enter the path to the target folder
        [Parameter(
        ValueFromPipeline=$True, 
        ValueFromPipelineByPropertyName=$True,
        Mandatory=$true,
        HelpMessage= 'Enter the path to the target folder'
        )]
        [ValidateScript({Test-Path $_})]
        [String[]]$Path,

        [String[]]$ignoreFilePath = $null

    )

    

    $path = $Path
    
    $currentPath = (Split-Path $Script:MyInvocation.MyCommand.Path -Parent) + '\'
   
    . ($currentPath + 'Get-Project-Reference.ps1')

    $langFile = $currentPath+'langs.config'
    $langs = @{}
    foreach ($lang in Import-Csv $langFile){
        if ($lang.Ext){
            $lang.Ext.Split(',') | % {$_.Trim()}|% {$_} { if (!$langs.ContainsKey($_)){ $langs+= @{$_ = $lang.Language}} } {$_}
        }
    }
    $ignorePatterns = @()
    if ($ignoreFilePath){
        $ignorePatterns = $ignoreFilePath | %{ Get-Content $_}| ? {$_ -notmatch '#' -and $_  } | % {$_ -replace '/','\\'}| % {$_ -replace '\*','*'} | % {$_ -replace '\*','.*'}
    }
    
    #$ignorePatterns
    
    '----------------Получаем список файлов--------'

    $files =  Get-Files-Not-Ignored -itemPath (Get-Item $path) -ignorePatterns $ignorePatterns
    
    $files | measure

    $filesGroup = $files  | Group-Object {$_.Extension -replace '\.', ''} 

    $filesGroup

    '----------------Отчет по типам файлов--------'

    $filesGroup  | % {New-Object psobject -Property @{
                            Lang = $langs[$_.Name]
                            Item = $_.Name
                            Sum = ($_.Group | Measure-Object Length -Sum).Sum
                            Count = ($_.Group | Measure-Object Length ).Count
                            }
                        } | Sort-Object -Property @{Expression='Lang'; Descending=$true} | Out-Default

    '---------------- csproj файлы --------'
    $projFiles = ($filesGroup | ? {$_.Name -eq 'csproj'})| %{$_.Group} | %{$_.Fullname}
    '-----------------|---> Ссылки'

    $projFiles

    $assemblies = $projFiles | Get-Project-References

    $assemblies | Out-Default

    '--------------------------------------------'
}

function Get-Files-Not-Ignored(){
[CmdletBinding()]
Param
    (
        # Enter the path to the target folder
        [Parameter(
        ValueFromPipeline=$True, 
        ValueFromPipelineByPropertyName=$True,
        Mandatory=$true,
        HelpMessage= 'Enter the path to the target folder'
        )]
        [String]$itemPath,

        [String[]]$ignorePatterns

    )

    $ignore = $false

    
    $filter = @()
    
    if (-not (Is-Name-Match-Patterns -name $itemPath -ignorePatterns $ignorePatterns)){
        $item = Get-Item $itemPath -Force
        if (-not $item -or ($item.Attributes | ? {$_.ToString() -match 'Hidden' }).Length -gt 0) {
            Write-Warning ("Какой-то странный файл. "+ $itemPath)
        }else{
            if ($item.GetType() -eq [System.IO.FileInfo]){
                Write-Verbose ($itemPath)
                return $item
            
            }
            else
            {
                $files = [System.IO.Directory]::GetFiles($itemPath) | % {Get-Files-Not-Ignored -itemPath $_ -ignorePatterns $ignorePatterns}
                $directories = [System.IO.Directory]::GetDirectories($itemPath) | % {Get-Files-Not-Ignored -itemPath $_ -ignorePatterns $ignorePatterns}
                $result =  @($files,$directories)
                return $result
            }
        }
    }
}

function Is-Name-Match-Patterns(){
[CmdletBinding()]
Param
    (
        [String]$name,
        [String[]]$ignorePatterns

    )
    
    $ignore = $false
    
    foreach($pattern in $ignorePatterns)
    {
        if ( $name -match $pattern){
            $ignore = $true
            break
        }               
                
    }
    return $ignore
}



 