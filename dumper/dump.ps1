param(
[String[]]$types = $null,
[switch]$restore,
[String]$elasticAddr ='http://localhost:9200/berth',
[String]$outputPath =$null
)
if (-not $outputPath){
    $outputPath =  split-path -parent $MyInvocation.MyCommand.Definition
}

$inputAddr = $elasticAddr
$outputAddr = $outputPath


foreach($type in $types)
{
    $outputL = join-path $outputAddr "$type.json"
    $inputL = $inputAddr

    if ($restore.IsPresent)
    {
        $tmp = $outputL
        $outputL = $inputL
        $inputL = $tmp
    }
    $outputL
    dumper\elasticdump.cmd --input=$inputL --input-index=$type --output=$outputL --limit 99999999
}


