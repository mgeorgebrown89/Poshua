$EndpointsPath = ($PSScriptRoot) | Join-Path -ChildPath "Poshua" | Join-Path -ChildPath "Endpoints"
$Endpoints = @()
foreach($e in (Get-ChildItem -Path $EndpointsPath -Recurse -File -Filter "*.ps1")){
    $Endpoints += . $e
}

Start-UDRestApi -Port 80 -Endpoint $Endpoints #-AutoReload

#Get-UDRestApi | Stop-UDRestApi