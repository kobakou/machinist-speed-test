##### include user settings #####
. ".\config.ps1"

##### config #####
$URI = 'https://gw.machinist.iij.jp/endpoint'
$HEADER = @{
    Authorization = "Bearer $API_KEY"
}

##### generate data #####
$RESULT = (.\speedtest.exe -s 48463 -f csv --output-header | ConvertFrom-Csv | Select-Object @{
        name='Download'
        expr={[Int]$_.download * 8}
    },
    @{
        name='RTT'
        expr={$_.'idle latency'}
    })
$DATA = @{
    agent_id = $AGENT_ID
    metrics = @(
        @{
            name = "Download"
            namespace = "Speedtest.net"
            data_point = @{
                value = $RESULT.Download
            }
        },
        @{
            name = "RTT"
            namespace = "Speedtest.net"
            data_point = @{
                value = [double]$RESULT.RTT
            }
        }
    )
}
$BODY = $DATA | ConvertTo-Json -Depth 5  # Depthオプションが無いとdata_point内がJSON化されない

echo $URI
echo $BODY

##### post data #####
Invoke-RestMethod -Method Post -ContentType 'application/json' -Headers $HEADER -Uri $URI -Body $BODY
