$server = "localhost"

# ADCP link port 53595
$port = 53595

$client = New-Object System.Net.Sockets.TcpClient($server, $port)

# does the terminator ned to be set? would be "CR/LF"
$stream = $client.GetStream()
$reader = New-Object System.IO.StreamReader($stream)
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true

$buffer = new-object System.Byte[] 1024
$encoding = new-object System.Text.AsciiEncoding

# getState function that returns day, night, and maybe outage

function togglePower ($state, $writer) {
    $command = If ($state -eq "night") {'power "on"'} Else {'power "off"'}
    $reader.ReadLine()

    $writer.Write($command)
}

while ($client.Connected) {
    # $currentState = getState()

    $clientState = $writer.WriteLine("power_status")
    
    If ($clientState -ne $currentState) {
        togglePower($state, $writer)
    }
}

$reader.Close()
$writer.Close()
try {
    $client.Close()
}
catch {
    Write-Outpute "Received error"
    Write-Output $_
}


