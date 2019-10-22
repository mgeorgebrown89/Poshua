New-UDEndpoint -Url "/interactivity" -Method "POST" -Endpoint {
    param($Payload)
    Wait-Debugger
    $Response = $Payload | ConvertFrom-Json -Depth 100
    $LogsPath = (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent ($PSScriptRoot)))))) | Join-Path -ChildPath "Logs"
    $Date = Get-Date -Format FileDateTime
    Out-File -FilePath "./Tests.json" -InputObject $Payload
}
