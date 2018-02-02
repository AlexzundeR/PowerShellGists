$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$install = Join-Path $executingScriptDirectory "install.ps1"
$uninstall = Join-Path $executingScriptDirectory "uninstall.ps1"

install -KeyName "product" -DisplayName "Product!" -Version 1.0.0.0 -publisher publisher -icon ""
uninstall -KeyName "product"

