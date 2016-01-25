function Get-Project-References(){
[CmdletBinding()]
Param
    (
        # Enter the path to the target folder
        [Parameter(
        ValueFromPipeline=$True, 
        ValueFromPipelineByPropertyName=$True,
        Mandatory=$true,
        HelpMessage= 'Enter the path to the project'
        )]
        [ValidateScript({Test-Path $_})]
        [String]$ProjectPath
    )

        

    $path = $ProjectPath
    Write-Verbose $path
    [xml] $xml = Get-Content $path
    $parentPath = Split-Path $path -Parent
    Write-Verbose $parentPath
    $references = $xml.Project.ItemGroup.Reference | %{
        $referencePath = ''
        $referenceType = ''
        if ($_.HintPath){
            if ([System.IO.Path]::IsPathRooted($_.HintPath)){
                $referencePath = $_.HintPath
                $referenceType = 'local'
            }
            else{
                $referencePath = [System.IO.Path]::GetFullPath((Join-Path -Path $parentPath -ChildPath $_.HintPath))
                $referenceType = 'local'
            }
        }
        else{
            $referencePath = $_.Include
            $referenceType = 'GAC'
        }

        New-Object psobject -Property @{
                            Path = $referencePath
                            Type = $referenceType
                            }
    } | ? {$_.Path}

    #"-----"
    #$references | % {$_.Path}
    #"-----"
    

    $refDatas = $references | %{
        $ref = $_
        try{
            $companyName =''
            $assemblyName =''
            $ass = $null
            if ($_.Type -eq 'GAC'){
                $ass = [System.Reflection.Assembly]::LoadWithPartialName($ref.Path)
             }
             else{
                $ass = [System.Reflection.Assembly]::LoadFile($ref.Path)
             }

             if ($ass){
                $companyName = (Get-Item  $ass.Location).VersionInfo.CompanyName
                $assemblyName = $ass.GetName().Name
             }

             New-Object psobject -Property @{
                                Name = $assemblyName
                                Company = $companyName
                                Path = $ref.Path
                                }
        }
        catch{
            Write-Warning ("Не удалось загрузить сборку "+($ref.Path) + " " + ($_.Exception.Message))
        }
    } 
    return $refDatas
 }


