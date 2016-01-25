$path = 'D:\Job\berth.starter'
$ignoreFile = 'D:\Job\berth\analyse\ignore.config'
$langFile = 'D:\Job\Berth\analyse\langs.config'
$langs = @{}
foreach ($lang in Import-Csv $langFile){
    if ($lang.Ext){
        $lang.Ext.Split(',') | % {$_.Trim()}|% {$_} { if (!$langs.ContainsKey($_)){ $langs+= @{$_ = $lang.Language}} } {$_}
    }
}
  
$ignorePatterns = Get-Content $ignoreFile | ? {$_ -notmatch '#' -and $_  } | % {$_ -replace '/','\\'}| % {$_ -replace '\*','*'} | % {$_ -replace '\*','.*'}
#$ignorePatterns


$files = Get-ChildItem $path -Recurse 
'Файлы'
$filterFiles = $files| ? {$_.GetType() -eq [System.IO.FileInfo]}|% { 
            $ignore = $false
            foreach($pattern in $ignorePatterns)
            {
           <# if ($_.FullName -match 'packages' -and $pattern -match 'packages'){
                Write-Host $pattern
                Write-Host ($_.FullName -match $pattern)
                } #>
                if ( $_.FullName -match $pattern){
                    $ignore = $true
                    break
                }               
                
            }
            if (!$ignore){
                return $_
            }
         }
$filesGroup = $filterFiles  | Group-Object {$_.Extension -replace '\.', ''} 

"

"

$filterFiles| ? {$_.Name -eq 'xml'} | % {$_.Group | % {$_.FullName}}


$filesGroup  | % {New-Object psobject -Property @{
                        Lang = $langs[$_.Name]
                        Item = $_.Name
                        Sum = ($_.Group | Measure-Object Length -Sum).Sum
                        Count = ($_.Group | Measure-Object Length ).Count
                        }
                    } | Out-Default

         
#         $files | % {$_.FullName}
#$files|? {$_.FullName -match 'bin\\'} | % {$_.FullName}


