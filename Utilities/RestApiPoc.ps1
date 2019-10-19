# Reference: https://tech.zsoldier.com/2018/08/powershell-making-restful-api-endpoint.html
# Reference: http://hkeylocalmachine.com/?p=518
# Create a listener on port 7000
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://+:7000/') 
$listener.Start()
'Listening ...'
 
# Run until you send a GET request to /end
while ($true) {
    $context = $listener.GetContext()
 
    # Capture the details about the request
    $request = $context.Request
    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $request.InputStream, $request.ContentEncoding
    
    # Setup a place to deliver a response
    $response = $context.Response

    if ($request.url.PathAndQuery -match '/end$')
    {Break}
    else {
        Switch ($request.Url.PathAndQuery) {
            default {
                $message = "<HTML><body>Unsupported</body></HTML>"
                        $response.ContentType = 'text/html'
                        $response.StatusCode = 400
            }
            "/" {
                Switch ($request.HttpMethod) {
                    default {
                        $message = "<HTML><body>Unsupported Method</body></HTML>"
                        $response.ContentType = 'text/html'
                        $response.StatusCode = 400
                        }
                    GET {
                        $message = "<HTML><body>Unsupported</body></HTML>"
                        $response.ContentType = 'text/html'
                        $response.StatusCode = 400
                    }
                    POST {
                        $message = "<HTML><body>Unsupported</body></HTML>"
                        $response.ContentType = 'text/html'
                        $response.StatusCode = 400
                    }
                }
            }
            "/whateveryouwant" {
                Switch ($request.HttpMethod) {
                default {
                        $message = "<HTML><body>Unsupported Method</body></HTML>"
                        $response.ContentType = 'text/html'
                        $response.StatusCode = 400
                        }
                    GET {
                        $message = "<HTML><body>yay</body></HTML>"
                        $response.ContentType = 'text/html'
                        $response.StatusCode = 400
                    }
                    POST {
                        $jsondata = $reader.readtoEnd()
            
                        # Convert from json to PSObject
                        IF (!($v = $jsondata | ConvertFrom-Json))
                        {
                            $message = '<HTML><body>Json validation failed.</body></HTML>'
                            $response.ContentType = 'text/html'
                            $response.StatusCode = 400
                        }
                        # If conversion fails, json format assumed incorrect.
                        
                        # Test Message, basically returns the json that was posted back to you.
                        $message = $v | ConvertTo-Json -Depth 10
                        $response.ContentType = 'application/json'
                    }
                }
            }
        }
        [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes($message)
        $response.ContentLength64 = $buffer.length
        $output = $response.OutputStream
        $output.Write($buffer, 0, $buffer.length)
        $output.Close()
    }
}
$listener.stop()
$listener.dispose()