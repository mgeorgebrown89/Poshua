Get-UDRestApi | Stop-UDRestApi
$Endpoint = New-UDEndpoint -Url "/interactivity" -Method "POST" -Endpoint {
    param($Payload)

    $Body = $Payload | ConvertFrom-Json -Depth 100

    $scriptBlock = {
        param($Body)
        $token = 'xoxp-643543980115-654972423648-643556889155-fae7b3458e989c7624556a4062831760'
        #Start-Sleep -Seconds 5
        Invoke-RestMethod -Method Post -Uri "https://slack.com/api/chat.postMessage" -Body @{text = $Body.user.username ; channel = "pslickpslack-testing" } -Headers @{Authorization = "Bearer $token" }
    }

    $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $Body
}
Start-UDRestApi -Port 80 -Endpoint $Endpoint #-AutoReload
